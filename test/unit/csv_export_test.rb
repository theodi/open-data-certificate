require_relative '../test_helper'

class CSVExportTest < ActiveSupport::TestCase

  test "job is enqueued for 3am the next day" do
    next_time = DateTime.now.utc.tomorrow.beginning_of_day + 3.hours
    Delayed::Job.expects(:enqueue).with(CSVExport, has_entries(:run_at => next_time))
    DatasetsCSV.any_instance.stubs(:save)
    Rackspace.stubs(:upload)
    CSVExport.perform
  end

  test "job is enqueued for 3am the next day after failure" do
    next_time = DateTime.now.utc.tomorrow.beginning_of_day + 3.hours
    Delayed::Job.expects(:enqueue).with(CSVExport, has_entries(:run_at => next_time))
    DatasetsCSV.any_instance.stubs(:save).raises(ArgumentError, 'deliberate failure')
    Rackspace.stubs(:upload)
    assert_raises ArgumentError do
      CSVExport.perform
    end
  end

  test "job is not enqued if there is already one pending" do
    Rackspace.stubs(:upload)
    DatasetsCSV.any_instance.stubs(:save)
    CSVExport.perform
    Delayed::Job.expects(:enqueue).never
    CSVExport.perform
  end

  test "download_url gets public_url for file" do
    # Demeterrrrrr!
    files = mock()
    dir = mock()
    Rackspace.stubs(:dir).returns(dir)
    dir.stubs(:files).returns(files)
    file = mock()
    files.expects(:head).with(CSVExport::FILENAME).returns(file)
    file.expects(:public_url).returns("http://rackspace.example.com/file.csv")

    assert_equal "http://rackspace.example.com/file.csv", CSVExport.download_url
  end

  test "download_url raises record not found if file is nil" do
    # Demeterrrrrr!
    files = mock()
    dir = mock()
    Rackspace.stubs(:dir).returns(dir)
    dir.stubs(:files).returns(files)
    files.stubs(:head).returns(nil)
    assert_raises(ActiveRecord::RecordNotFound) do
      CSVExport.download_url
    end
  end

end
