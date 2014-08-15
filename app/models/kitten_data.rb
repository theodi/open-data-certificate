class KittenData < ActiveRecord::Base
  belongs_to :response_set

  attr_accessible :data, :url, :response_set

  serialize :data

  DATA_LICENCES = {
    "http://opendatacommons.org/licenses/by/" => "odc_by",
    "http://opendatacommons.org/licenses/odbl/" => "odc_odbl",
    "http://opendatacommons.org/licenses/pddl/" => "odc_pddl",
    "http://creativecommons.org/publicdomain/zero/1.0/" => "cc_zero",
    "http://reference.data.gov.uk/id/open-government-licence" => "ogl_uk",
    "http://www.nationalarchives.gov.uk/doc/open-government-licence/version/2/" => "ogl_uk"
  }

  CONTENT_LICENCES = {
    "http://creativecommons.org/licenses/by/2.0/uk/" => "cc_by",
    "http://creativecommons.org/licenses/by-sa/2.0/uk/" => "cc_by_sa",
    "http://creativecommons.org/publicdomain/zero/1.0/" => "cc_zero",
    "http://reference.data.gov.uk/id/open-government-licence" => "ogl_uk",
    "http://www.nationalarchives.gov.uk/doc/open-government-licence/version/2/" => "ogl_uk"
  }

  def dataset
    @dataset
  end

  def request_data
    @dataset = DataKitten::Dataset.new(access_url: url) rescue nil

    if @dataset && @dataset.supported? && dataset_field(:data_title)
      self.data = {
        :title             => dataset_field(:data_title, ''),
        :description       => dataset_field(:description, ''),
        :publishers        => dataset_field(:publishers, []),
        :rights            => dataset_field(:rights),
        :licenses          => dataset_field(:licenses, []),
        :update_frequency  => dataset_field(:update_frequency, ''),
        :keywords          => dataset_field(:keywords, []),
        :release_date      => dataset_field(:issued),
        :modified_date     => dataset_field(:modified),
        :temporal_coverage => dataset_field(:temporal, DataKitten::Temporal.new({})),
        :distributions     => distributions
      }
    else
      self.data = false
    end
  end

  def distributions
    dataset_field(:distributions, []).map { |distribution|
      {
        :title       => distribution.title,
        :description => distribution.description,
        :access_url  => distribution.access_url,
        :extension   => distribution.format.try(:extension),
        :open        => distribution.format.try(:open?),
        :structured  => distribution.format.try(:structured?)
      }
    }
  end

  def fields
    @fields || compute_fields
  end

  def compute_fields
    return {} if !data

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

  protected

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
    @fields["dataLicence"] = KittenData::DATA_LICENCES[data[:licenses][0].uri]

    @fields["contentLicence"] = "ogl_uk" if @fields["dataLicence"] == "ogl_uk"

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
      check_frequency
    end
  end

  def set_dgu_assumptions
    return unless url.include?("data.gov.uk")
    # Assumptions for data.gov.uk
    uri = URI(url)
    package = uri.path.split("/").last

    @fields["publisherOrigin"] = "true"
    @fields["copyrightURL"] = url
    @fields["dataPersonal"] = "not_personal"
    @fields["frequentChanges"] = "false"
    @fields["listed"] = "true"
    @fields["listing"] = "http://data.gov.uk"
    @fields["vocabulary"] = "false"
    @fields["codelists"] = "false"
    @fields["contentRights"] = "samerights"
    @fields["versionManagement"] = ["list"]
    @fields["versionsUrl"] = "http://data.gov.uk/api/rest/package/#{package}"
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
      "description" =>  :description,
      "accrualPeriodicity" => :update_frequency,
      "publisher" => :publishers,
      "keyword" => :keywords,
      "distribution" => :distributions
    }.each do |k,v|
        @fields["documentationMetadata"].push(k) unless data[v].empty?
    end

    {
      "issued" => :release_date,
      "modified" => :modified_date
    }.each do |k,v|
        @fields["documentationMetadata"].push(k) unless data[v].nil?
    end

    @fields["documentationMetadata"].push("temporal") unless data[:temporal_coverage].start.nil? && data[:temporal_coverage].end.nil?
  end

  def check_frequency
    if data[:update_frequency].empty?
      data[:distributions].length == 1 ? @fields["releaseType"] = "oneoff" : @fields["releaseType"] = "collection"
    else
      data[:distributions].length > 1 if @fields["releaseType"] = "series"
    end
  end

  private
  def dataset_field(method, default = nil)
    @dataset.try(method) || default
  end

end
