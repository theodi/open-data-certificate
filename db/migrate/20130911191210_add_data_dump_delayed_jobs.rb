class AddDataDumpDelayedJobs < ActiveRecord::Migration
  def up
    Delayed::Job.enqueue StatsDump, { :priority => 5, :run_at => DateTime.now.tomorrow.change(:hour => 1, :min => 30) }
    Delayed::Job.enqueue CertificateDump, { :priority => 5, :run_at => DateTime.now.tomorrow.change(:hour => 2, :min => 0) }
  end

  def down
    stats = Delayed::Job.enqueue StatsDump, { :priority => 5, :run_at => DateTime.now.tomorrow.change(:hour => 1, :min => 30) }
    stats.delete
    
    cert = Delayed::Job.enqueue CertificateDump, { :priority => 5, :run_at => DateTime.now.tomorrow.change(:hour => 2, :min => 0) }
    cert.delete
  end
end
