class KittenData < ActiveRecord::Base
  belongs_to :response_set

  attr_accessible :data, :url, :response_set

  serialize :data

  DATA_LICENCES = {
    "http://opendatacommons.org/licenses/by/" => "odc_by",
    "http://opendatacommons.org/licenses/odbl/" => "odc_odbl",
    "http://opendatacommons.org/licenses/pddl/" => "odc_pddl",
    "http://creativecommons.org/publicdomain/zero/1.0/" => "cc_zero",
    "http://reference.data.gov.uk/id/open-government-licence" => "ogl_uk"
  }

  CONTENT_LICENCES = {
    "http://creativecommons.org/licenses/by/2.0/uk/" => "cc_by",
    "http://creativecommons.org/licenses/by-sa/2.0/uk/" => "cc_by_sa",
    "http://creativecommons.org/publicdomain/zero/1.0/" => "cc_zero",
    "http://reference.data.gov.uk/id/open-government-licence" => "ogl_uk"
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
        :distributions     => dataset_field(:distributions, []).map { |distribution|
          {
            :title       => distribution.title,
            :description => distribution.description,
            :access_url  => distribution.access_url,
            :extension   => distribution.format.try(:extension),
            :open        => distribution.format.try(:open?),
            :structured  => distribution.format.try(:structured?)
          }
        }
      }
    else
      self.data = false
    end
  end

  def fields
    @fields || compute_fields
  end

  def compute_fields
    @fields = {}

    return @fields if !data

    begin

    @fields["dataTitle"] = data[:title]

    if data[:publishers].any?
      @fields["publisher"] = data[:publishers][0].name
      @fields["publisherUrl"] = data[:publishers][0].homepage
      @fields["contactEmail"] = data[:publishers][0].mbox
    end

    # Release type
    if data[:update_frequency].empty? && data[:distributions].length == 1
      @fields["releaseType"] = "oneoff"
    elsif data[:update_frequency].empty? && data[:distributions].length > 1
      @fields["releaseType"] = "collection"
    elsif !data[:update_frequency].empty? && data[:distributions].length > 1
      @fields["releaseType"] = "series"
    end

    if data[:title].include?("API") || data[:description].include?("API")
      @fields["releaseType"] = "service"
    end

    if data[:rights]
      @fields["publisherRights"] = "yes"
      @fields["copyrightURL"] = data[:rights].uri
      @fields["dataLicence"] = KittenData::DATA_LICENCES[data[:rights].dataLicense]
      @fields["contentLicence"] = KittenData::CONTENT_LICENCES[data[:rights].contentLicense]

    elsif data[:licenses].any?
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

    # Assumptions for data.gov.uk
    if url.include?("data.gov.uk")
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

    # Checks if any of the distributions are machine readable or open
    @fields["machineReadable"] = "true" if data[:distributions].detect{|d| d[:structured] }
    @fields["openStandard"] = "true" if data[:distributions].detect{|d| d[:open] }

    # Does your data documentation contain machine readable documentation for:
    metadata = []
    metadata.push("title") unless data[:title].empty?
    metadata.push("description") unless data[:description].empty?
    metadata.push("issued") unless data[:release_date].nil?
    metadata.push("modified") unless data[:modified_date].nil?
    metadata.push("accrualPeriodicity") unless data[:update_frequency].empty?
    metadata.push("publisher") unless data[:publishers].empty?
    metadata.push("keyword") unless data[:keywords].empty?
    metadata.push("distribution") unless data[:distributions].empty?
    metadata.push("temporal") unless data[:temporal_coverage].start.nil? && data[:temporal_coverage].end.nil?

    @fields["documentationMetadata"] = metadata

    rescue => ex
      if defined? notify_airbrake
        notify_airbrake ex
      end
    end

    @fields
  end

  private
  def dataset_field(method, default = nil)
    @dataset.try(method) || default
  end
end
