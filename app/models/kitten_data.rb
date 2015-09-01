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

  def source
    @dataset.try(:source) || {}
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

  def original_resources
    if source.present? && source["resources"].present?
      source["resources"]
    else
      []
    end
  end

  def is_service?
    data[:title].include?("API") || 
    data[:description].include?("API") ||
    original_resources.any? { |r| r["resource_type"] == "api" }
  end

  def get_release_type
    # this is where data.gov.uk provides type of release
    resource_type = source["extras"]["resource-type"] rescue nil

    # data.gov uses extras["collection_metadata"] = "true" for collections.
    is_collection = source["extras"]["collection_metadata"] == "true" rescue false
    return "collection" if is_collection

    if ["service", "series"].include?(resource_type)
      resource_type
    elsif is_service?
      "service"
    else
      check_frequency
    end
  end

  def set_release_type
    @fields["releaseType"] = get_release_type
  end

  def set_service_type
    return unless @fields["releaseType"] == "service"
    @fields["serviceType"] = "changing" if data[:update_frequency].present?
  end

  def set_data_type
    is_geographic = source["extras"]["metadata_type"] == "geospatial" rescue false
    @fields["dataType"] = "geographic" if is_geographic
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
    @fields["onWebsite"] = "true"
    @fields["contactUrl"] = url
    @fields["listing"] = "#{uri.scheme}://#{hostname}"
    @fields["versionManagement"] = ["list"]
    @fields["versionsUrl"] = "http://#{hostname}/api/rest/package/#{package_name}"
  end

  def set_data_gov_uk_assumptions
    return unless hostname == "data.gov.uk"
    
    @fields["improvementsContact"] = URI.join(url + "/", "feedback/view").to_s
    
    sla = source["extras"]["sla"] == "true" rescue false
    
    if sla
      @fields["slaUrl"] = url
      @fields["onGoingAvailability"] = "medium"
    end
  end

  def set_data_gov_assumptions
    return unless hostname == "catalog.data.gov"

    @fields["improvementsContact"] = "http://www.data.gov/issue/?media_url=#{url}"

    begin
      publisher_id = source["organization"]["id"]
      publisher = DataKitten::Fetcher.new("http://catalog.data.gov/api/2/rest/group/#{publisher_id}").as_json
      is_federal = publisher["extras"]["organization_type"] == "Federal Government"
      data_gov_federal_assumptions if is_federal
    rescue
      nil
    end
  end

  def data_gov_federal_assumptions
    @fields["dataLicence"] = "other"
    @fields["contentLicence"] = "other"
    @fields["otherDataLicenceName"] = "U.S. Government Work"
    @fields["otherDataLicenceURL"] = "http://www.usa.gov/publicdomain/label/1.0/"
    @fields["otherDataLicenceOpen"] = "true"
    @fields["otherContentLicenceName"] = "U.S. Government Work"
    @fields["otherContentLicenceURL"] = "http://www.usa.gov/publicdomain/label/1.0/"
    @fields["otherContentLicenceOpen"] = "true"
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

  def set_distribution_metadata
    @fields["distributionMetadata"] = []
    
    {
      "title" => :title,
      "description" => :description,
      "issued" => :issued,
      "modified" => :modified,
      "rights" => :rights,
      "accessURL" => :access_url,
      "downloadURL" => :download_url,
      "byteSize" => :byte_size,
      "mediaType" => :media_type
    }.each do |k,v|
      if data[:distributions].all? {|d| d[v].present? }
        @fields["distributionMetadata"].push(k)
      end
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
  
  def set_time_sensitive
    if data[:temporal_coverage].present?
      @fields["timeSensitive"] = "timestamped"
    end
  end

  def set_frequent_changes
    return unless data[:update_frequency].present?
    at_least_daily = /(day|daily|hour|minute|second|real-?time)/i
    @fields["frequentChanges"] = if data[:update_frequency] =~ at_least_daily
      "true"
    else
      "false"
    end
  end

  def set_documentation
    resource = original_resources.find { |r| r["resource_type"] == "documentation" }
    @fields["technicalDocumentation"] = resource["url"] unless resource.blank?
  end

  def set_codelists
    codelists = source["codelist"] || source["extras"]["codelist"]
    @fields["codelists"] = "true" if codelists.present?
    @fields["codelistDocumentationUrl"] = codelists[0]["url"]
  rescue NoMethodError
    nil
  end

  def set_schema
    schema = source["schema"] rescue nil
    resource_schemas = original_resources.select { |r| r["schema-url"].present? }
    @fields["vocabulary"] = "true" if schema.present? || resource_schemas.present?
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
