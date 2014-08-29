require 'test_helper'

class GenerateStatsTest < ActiveSupport::TestCase

  should "generate correct number of stats" do
    GenerateStats.perform

    assert_equal Stat.all.count, 2
  end

  should "requeue job after run" do
    Timecop.freeze do
      Delayed::Job.expects(:enqueue).with(GenerateStats, { :priority => 5, :run_at => 1.day.from_now })
      GenerateStats.perform
    end
  end

end
