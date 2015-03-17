module CSVExport
  extend RecurringJob

  FILENAME = 'open-data-certificates.csv'
  METADATA = {
    content_type: 'text/csv',
    content_disposition: 'attachment'
  }

  def self.perform
    reenqueue_job do
      begin
        tmp = Tempfile.new('datasets.csv')
        DatasetsCSV.new(Dataset.visible).save(tmp.path)
        Rackspace.upload(FILENAME, File.open(tmp.path), METADATA)
      ensure
        tmp.close!
      end
    end
  end

  def self.next_run_date
    DateTime.now.utc.tomorrow.beginning_of_day + 3.hours
  end

  def self.download_url
    if file = Rackspace.dir.files.head(FILENAME)
      file.public_url
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
