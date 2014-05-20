class AddUploadUsageDataDelayedJob < ActiveRecord::Migration
  def up
    Delayed::Job.enqueue UploadUsageData, { :priority => 5, :run_at => DateTime.now.tomorrow.change(:hour => 2, :min => 00) }
  end

  def down
    stats = Delayed::Job.enqueue UploadUsageData, { :priority => 5, :run_at => DateTime.now.tomorrow.change(:hour => 2, :min => 00) }
    stats.delete
  end
end
