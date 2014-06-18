require 'csv'
require 'rackspace'

module StatsDump
  FILENAME = "statistics.csv"

  def self.perform
    file = Rackspace.dir.files.head FILENAME
    if file.nil?
      setup
    else
      latest
    end
    Delayed::Job.enqueue StatsDump, { :priority => 5, :run_at => 1.day.from_now }
  end

  def self.setup
    csv = CSV.generate do |csv|
      csv << [
          "Date",
          "All surveys started",
          "All Certificates",
          "All Datasets",
          "Published Certificates",
          "Published Datasets",
          "Raw level Certificates",
          "Pilot level Certificates",
          "Standard level Certificates",
          "Expert level Certificates",
        ]
      csv << stats_row
    end

    Rackspace.upload(FILENAME, csv)
  end

  def self.latest
    file = Rackspace.dir.files.head FILENAME
    csv = CSV.parse(file.body)
    csv << stats_row

    body = CSV.generate do |body|
      csv.each { |row| body << row }
    end

    Rackspace.upload(FILENAME, body)
  end

  def self.stats_row
    [
      Date.today.to_s,
      Stats::Certificate.counts[:all],
      Stats::ResponseSet.counts[:all],
      Stats::ResponseSet.counts[:all_datasets],
      Stats::Certificate.counts[:published],
      Stats::ResponseSet.counts[:published_datasets],
      Stats::Certificate.counts[:levels][:basic],
      Stats::Certificate.counts[:levels][:pilot],
      Stats::Certificate.counts[:levels][:standard],
      Stats::Certificate.counts[:levels][:expert]
    ]
  end

end
