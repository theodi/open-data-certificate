require 'test_helper'

class CSVExportTest < ActiveSupport::TestCase

  test "job is enqueued for 3am the next day" do
    next_time = DateTime.now.utc.tomorrow.beginning_of_day + 3.hours
    Delayed::Job.expects(:enqueue).with(CSVExport, has_entries(:run_at => next_time))
    DatasetsCSV.any_instance.stubs(:save)
    CSVExport.perform
  end

  test "job is enqueued for 3am the next day after failure" do
    next_time = DateTime.now.utc.tomorrow.beginning_of_day + 3.hours
    Delayed::Job.expects(:enqueue).with(CSVExport, has_entries(:run_at => next_time))
    DatasetsCSV.any_instance.stubs(:save).raises(ArgumentError, 'deliberate failure')
    assert_raises ArgumentError do
      CSVExport.perform
    end
  end

  test "job is not enqued if there is already one pending" do
    DatasetsCSV.any_instance.stubs(:save)
    CSVExport.perform
    Delayed::Job.expects(:enqueue).never
    CSVExport.perform
  end
end
