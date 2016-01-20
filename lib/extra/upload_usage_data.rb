require 'google_drive'

module UploadUsageData
  extend RecurringJob

  def self.perform
    reenqueue_job do
      [
        "published",
        "all"
      ].each do |type|
        data = certificate_data_by_type(type)
        unless data.empty?
          csv = create_csv(data)
          upload_csv(csv, "#{type.humanize} - #{Date.today.to_s}")
        end
      end
    end
  end

  def self.certificate_data_by_type(type)
    certificates = Certificate.send(type)
    return certificates.map do |cert|
      CertificatePresenter.new(cert).send("#{type}_data")
    end
  end

  def self.create_csv(data)
    csv = CSV.generate(force_quotes: true, row_sep: "\r\n") do |csv|
      # Header row goes here
      headers = data.first.keys
      csv << headers

      data.each {|c| csv << headers.map { |h| c[h] } }
    end
  end

  def self.find_collection(path)
    segments = path.split("/")
    segments.reduce(session.root_collection) do |collection, path_segment|
      collection.subcollection_by_title(path_segment) ||
        collection.create_subcollection(path_segment)
    end
  end

  def self.upload_csv(csv, title)
    file = session.upload_from_string(csv, title, content_type: "text/csv")
    collection = find_collection(ENV['GAPPS_CERTIFICATE_USAGE_COLLECTION'] || '')
    collection.add(file)
  end

  def self.session
    @session ||= GoogleDrive.login(ENV['GAPPS_USER_EMAIL'], ENV['GAPPS_PASSWORD'])
  end

  def self.next_run_date
    DateTime.now.utc.next_week
  end

end
