class KittenData < ActiveRecord::Base
  belongs_to :response_set

  attr_accessible :data

  serialize :data

  DATA_LICENCES = {
    "http://opendatacommons.org/licenses/by/": "odc_by",
    "http://opendatacommons.org/licenses/odbl/": "odc_odbl",
    "http://opendatacommons.org/licenses/pddl/": "odc_pddl",
    "http://creativecommons.org/publicdomain/zero/1.0/": "cc_zero",
    "http://reference.data.gov.uk/id/open-government-licence": "uk_ogl",
    "http://www.ordnancesurvey.co.uk/docs/licences/os-opendata-licence.pdf": "other"
  }

  CONTENT_LICENCES = {
    "http://creativecommons.org/licenses/by/2.0/uk/": "cc_by",
    "http://creativecommons.org/licenses/by-sa/2.0/uk/": "cc_by_sa",
    "http://creativecommons.org/publicdomain/zero/1.0/": "cc_zero",
    "http://reference.data.gov.uk/id/open-government-licence": "uk_ogl"
  }

  def map
    fields = {}

    fields["dataTitle"] = data[:title]

    if data[:publishers].any?
      fields["publisher"] = data[:publishers][0].name
      fields["publisherUrl"] = data[:publishers][0].homepage
      fields["contactEmail"] = data[:publishers][0].mbox
    end

    # Release type
    if data[:update_frequency].empty? && data[:distributions].length == 1
      fields["releaseType"] = "oneoff"
    elsif data[:update_frequency].empty? && data[:distributions].length > 1
      fields["releaseType"] = "collection"
    elsif data[:update_frequency].any? && data[:distributions].length > 1
      fields["releaseType"] = "series"
    end

    if data[:title].include?("API") || data[:description].include?("API")
      fields["releaseType"] = "service"
    end

    if data[:rights]
      fields["publisherRights"] = "yes"
      fields["copyrightURL"] = data[:rights].uri
      fields["dataLicence"] = KittenData::DATA_LICENCES[data[:rights].dataLicense]
      fields["contentLicence"] = KittenData::CONTENT_LICENCES[data[:rights].contentLicense]

    elsif data[:licenses].any?
      fields["publisherRights"] = "yes"
      fields["dataLicence"] = KittenData::DATA_LICENCES[data[:licenses][0].uri]

      fields["contentLicence"] = "uk_ogl" if fields["dataLicence"] == "uk_ogl"

      if fields["dataLicence"] == "other"
        fields["contentLicence"] = "other"
        fields["otherDataLicenceName"] = "OS OpenData Licence"
        fields["otherDataLicenceURL"] = "http://www.ordnancesurvey.co.uk/docs/licences/os-opendata-licence.pdf"
        fields["otherDataLicenceOpen"] = "true"
        fields["otherContentLicenceName"] = "OS OpenData Licence"
        fields["otherContentLicenceURL"] = "http://www.ordnancesurvey.co.uk/docs/licences/os-opendata-licence.pdf"
        fields["otherContentLicenceOpen"] = "true"
      end
    end

    # Assumptions for data.gov.uk
    if url.include?("data.gov.uk")
      fields["publisherOrigin"] = "true"
      fields["dataPersonal"] = "not_personal"
      fields["frequentChanges"] = "false"
      fields["vocabulary"] = "false"
      fields["codelists"] = "false"
    end

    # Checks if any of the distributions are machine readable or open
    data[:distributions].map do |distribution|
      if data[:distributions][i].structured
        fields["machineReadable"] = "true"
      end

      if data[:distributions][i].open
        fields["openStandard"] = "true"
      end
    end

    # Does your data documentation contain machine readable documentation for:
    metadata = []
    metadata.push("title") unless data[:title].empty?
    metadata.push("description") unless data[:description].empty?
    metadata.push("issued") unless data[:release_date].empty?
    metadata.push("modified") unless data[:modified_date].empty?
    metadata.push("accrualPeriodicity") unless data[:update_frequency].empty?
    metadata.push("publisher") unless data[:publishers].empty?
    metadata.push("keyword") unless data[:keywords].empty?
    metadata.push("distribution") unless data[:distributions].empty?
    metadata.push("temporal") unless data[:temporal_coverage].start.nil? && data[:temporal_coverage].end.nil?

    fields["documentationMetadata"] = metadata
  end
end
