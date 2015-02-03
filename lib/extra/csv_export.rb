module CSVExport
  extend RecurringJob

  PATH = Rails.root.join('public/system/datasets.csv')

  def self.perform
    reenqueue_job do
      DatasetsCSV.new(Dataset.visible).save(PATH)
    end
  end

  def self.next_run_date
    DateTime.now.utc.tomorrow.beginning_of_day + 3.hours
  end
end
