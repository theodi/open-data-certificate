class AddGenerateStatsDelayedJob < ActiveRecord::Migration
  def up
    Delayed::Job.enqueue GenerateStats, { :priority => 5, :run_at => DateTime.now.tomorrow.change(:hour => 3, :min => 00) }
  end

  def down
    stats = Delayed::Job.enqueue GenerateStats, { :priority => 5, :run_at => DateTime.now.tomorrow.change(:hour => 3, :min => 00) }
    stats.delete
  end
end
