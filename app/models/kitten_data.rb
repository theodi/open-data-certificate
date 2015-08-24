class KittenData < ActiveRecord::Base
  belongs_to :response_set

  attr_accessible :data, :url, :response_set

  serialize :data

  after_initialize :request_data, :if => :new_record?

  DATA_LICENCES = {
    "http://opendatacommons.org/licenses/by/" => "odc_by",
    "http://opendatacommons.org/licenses/odbl/" => "odc_odbl",
    "http://opendatacommons.org/licenses/pddl/" => "odc_pddl",
    "http://creativecommons.org/publicdomain/zero/1.0/" => "cc_zero",
    "http://reference.data.gov.uk/id/open-government-licence" => "ogl_uk",
    "http://www.nationalarchives.gov.uk/doc/open-government-licence/version/2/" => "ogl_uk",
    "http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/" => "ogl_uk"
  }

  CONTENT_LICENCES = {
    "http://creativecommons.org/licenses/by/2.0/uk/" => "cc_by",
    "http://creativecommons.org/licenses/by-sa/2.0/uk/" => "cc_by_sa",
    "http://creativecommons.org/publicdomain/zero/1.0/" => "cc_zero",
    "http://reference.data.gov.uk/id/open-government-licence" => "ogl_uk",
    "http://www.nationalarchives.gov.uk/doc/open-government-licence/version/2/" => "ogl_uk",
    "http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/" => "ogl_uk"
  }

  KNOWN_LICENCES = ["odc_by", "odc_odbl", "odc_pddl", "cc_by", "cc_by_sa", "cc_zero", "ogl_uk"]
  KNOWN_CONTENT_LICENCES = ["cc_by", "cc_by_sa", "cc_zero", "ogl_uk"]

  def dataset
    @dataset
  end

  def distributions
    dataset_field(:distributions, []).map { |distribution|
      {
        :title        => distribution.title,
        :description  => distribution.description,
        :issued       => distribution.issued,
        :modified     => distribution.modified,
        :access_url   => distribution.access_url,
        :download_url => distribution.download_url,
        :byte_size    => distribution.byte_size,
        :media_type   => distribution.media_type,
        :extension    => distribution.format.try(:extension),
        :open         => distribution.format.try(:open?),
        :structured   => distribution.format.try(:structured?)
      }
    }
  end

  def fields
    @fields || compute_fields
  end

  def compute_fields
    return {} if data.blank?

    begin
      @fields = {}

      KittenData.instance_methods(false).each do |method|
        self.send(method) if method.match(/set_[a-z_]+/)
      end
    rescue => ex
      if defined? notify_airbrake
        notify_airbrake ex
      end
    end

    @fields
  end

  def contacts_with_email
    agents = [data.values_at(:publishers, :maintainers, :contributors)].flatten.compact
    agents.select { |contact| contact.mbox.present? }
  end

  def has_data?
    data.present?
  end

  def get(field)
    data[field].presence if has_data?
  end

  def get_list(field)
    get(field) || []
  end

  def uri
    @uri ||= URI(url)
  end

  def hostname
    uri.hostname
  end

  protected

  def package_name
    uri.path.split("/").last
  end

  def set_title
    @fields["dataTitle"] = data[:title]
  end

  def set_publisher
    return unless data[:publishers].any?

    @fields["publisher"] = data[:publishers][0].name
    @fields["publisherUrl"] = data[:publishers][0].homepage
    @fields["contactEmail"] = data[:publishers][0].mbox
  end

  def set_rights
    return unless data[:rights]

    @fields["publisherRights"] = "yes"
    @fields["copyrightURL"] = data[:rights].uri
    @fields["dataLicence"] = KittenData::DATA_LICENCES[data[:rights].dataLicense]
    @fields["contentLicence"] = KittenData::CONTENT_LICENCES[data[:rights].contentLicense]
  end

  def set_license
    return if @fields["dataLicence"]
    return unless data[:licenses].any?

    @fields["publisherRights"] = "yes"

    data_licence = data[:licenses][0].abbr.try(:underscore) unless data[:licenses].empty?
    
    @fields["dataLicence"] = data_licence if KNOWN_LICENCES.include? data_licence
    @fields["contentLicence"] = data_licence if KNOWN_CONTENT_LICENCES.include? data_licence

    # Settings for ordnance survey licences
    if data[:licenses][0].uri == "http://www.ordnancesurvey.co.uk/docs/licences/os-opendata-licence.pdf"
      @fields["dataLicence"] = "other"
      @fields["contentLicence"] = "other"
      @fields["otherDataLicenceName"] = "OS OpenData Licence"
      @fields["otherDataLicenceURL"] = "http://www.ordnancesurvey.co.uk/docs/licences/os-opendata-licence.pdf"
      @fields["otherDataLicenceOpen"] = "true"
      @fields["otherContentLicenceName"] = "OS OpenData Licence"
      @fields["otherContentLicenceURL"] = "http://www.ordnancesurvey.co.uk/docs/licences/os-opendata-licence.pdf"
      @fields["otherContentLicenceOpen"] = "true"
    end
  end

  def set_release_type
    if data[:title].include?("API") || data[:description].include?("API")
      @fields["releaseType"] = "service"
    else
      @fields["releaseType"] = check_frequency
    end
  end

  def set_basic_requirements
    # These should probably only be assumed on imports from government portals
    # see discussion on https://github.com/theodi/open-data-certificate/issues/1090
    @fields["publisherOrigin"] = "true"
    @fields["dataPersonal"] = "not_personal"
    @fields["contentRights"] = "samerights"
    @fields["codelists"] = "false"
    @fields["vocabulary"] = "false"
  end

  def set_ckan_assumptions
    # Assumptions for data.gov.uk
    # also for data.london.gov.uk
    # copied from dgu assumptions with confirmation from Ross Jones that they seemed sensible
    # and data.gov
    return unless %w[data.gov.uk data.london.gov.uk catalog.data.gov].include?(hostname)

    @fields["copyrightURL"] = url
    @fields["frequentChanges"] = "false"
    @fields["listed"] = "true"
    @fields["listing"] = "#{uri.scheme}://#{hostname}"
    @fields["versionManagement"] = ["list"]
    @fields["versionsUrl"] = "http://#{hostname}/api/rest/package/#{package_name}"
  end

  def set_structured_open
    # Checks if any of the distributions are machine readable or open
    @fields["machineReadable"] = "true" if data[:distributions].detect{|d| d[:structured] }
    @fields["openStandard"] = "true" if data[:distributions].detect{|d| d[:open] }
  end

  def set_metadata
    @fields["documentationMetadata"] = []

    # Does your data documentation contain machine readable documentation for:
    {
      "title" => :title,
      "description" => :description,
      "identifier" => :identifier,
      "landingPage" => :landing_page,
      "accrualPeriodicity" => :update_frequency,
      "publisher" => :publishers,
      "keyword" => :keywords,
      "theme" => :theme,
      "distribution" => :distributions,
      "issued" => :release_date,
      "modified" => :modified_date,
      "temporal" => :temporal_coverage,
      "spatial" => :spatial_coverage,
      "language" => :language
    }.each do |k,v|
      @fields["documentationMetadata"].push(k) unless data[v].blank?
    end
  end

  def check_frequency
    num_distributions = data[:distributions].length
    if data[:update_frequency].blank?
      num_distributions == 1 ? "oneoff" : "collection"
    elsif num_distributions > 1
      "series"
    else
      "oneoff"
    end
  end

  def set_dataset_url
    if check_frequency == "oneoff"
      @fields["datasetUrl"] = data[:distributions][0][:download_url]
    end
  end

  private
  def dataset_field(method, default = nil)
    @dataset.try(method) || default
  end

  def request_data
    @dataset ||= DataKitten::Dataset.new(access_url: url) rescue nil

    if @dataset && @dataset.supported? && dataset_field(:data_title)
      self.data = {
        :title             => dataset_field(:data_title),
        :description       => dataset_field(:description),
        :identifier        => dataset_field(:identifier),
        :landing_page      => dataset_field(:landing_page),
        :publishers        => dataset_field(:publishers, []),
        :maintainers       => dataset_field(:maintainers, []),
        :contributors      => dataset_field(:contributors, []),
        :rights            => dataset_field(:rights),
        :licenses          => dataset_field(:licenses, []),
        :update_frequency  => dataset_field(:update_frequency),
        :keywords          => dataset_field(:keywords, []),
        :theme             => dataset_field(:theme),
        :release_date      => dataset_field(:issued),
        :modified_date     => dataset_field(:modified),
        :temporal_coverage => dataset_field(:temporal),
        :spatial_coverage  => dataset_field(:spatial),
        :language          => dataset_field(:language),
        :distributions     => distributions
      }
    else
      self.data = {}
    end
  end

end
