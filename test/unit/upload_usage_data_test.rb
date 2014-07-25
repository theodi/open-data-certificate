require 'test_helper'

class UploadUsageDataTest < ActiveSupport::TestCase

  test "create_csvs creates a CSV file with correct stuff" do
    VCR.use_cassette('create_csvs creates a CSV file with correct stuff') do
      5.times do
        FactoryGirl.create(:published_certificate_with_dataset)
      end

      certificates = Certificate.published
      data = certificates.map do |cert|
        CertificatePresenter.new(cert).published_data
      end

      csv = UploadUsageData.create_csv(data)

      assert_equal 6, CSV.parse(csv).count
      assert_true Csvlint::Validator.new( StringIO.new(csv) ).valid?
    end
  end

  test "create_csvs shouldn't choke on blank rows" do
    data = [{foo: "foo", baz: "baz"}, nil, {foo: "baz", baz: "foo"}, nil]
    csv = UploadUsageData.create_csv(data)

    assert_equal 3, CSV.parse(csv).count
    assert_true Csvlint::Validator.new( StringIO.new(csv) ).valid?
  end

  test "find_collection finds the corrrect collection" do
    VCR.use_cassette('find_collection finds the corrrect collection') do
      collection = UploadUsageData.find_collection(ENV['GAPPS_CERTIFICATE_USAGE_COLLECTION'] || '')
      assert_equal "Usage Data", collection.title
    end
  end

  test "upload_csv uploads a csv" do
    VCR.use_cassette('upload_csv uploads a csv') do
      5.times do
        FactoryGirl.create(:published_certificate_with_dataset)
      end

      certificates = Certificate.published

      data = certificates.map do |cert|
        CertificatePresenter.new(cert).published_data
      end

      csv = UploadUsageData.create_csv(data)

      session = GoogleDrive.login(ENV['GAPPS_USER_EMAIL'], ENV['GAPPS_PASSWORD'])

      UploadUsageData.upload_csv(csv, 'ODCs Test file upload')

      file = session.file_by_title('ODCs Test file upload')
      collection = UploadUsageData.find_collection(ENV['GAPPS_CERTIFICATE_USAGE_COLLECTION'] || '')

      assert_equal 'ODCs Test file upload', file.title
      assert_equal 1, collection.files.select {|f| f.title == 'ODCs Test file upload'}.count
    end
  end

  test "perform uploads the correct files" do
    VCR.use_cassette('perform uploads the correct files') do
      5.times do
        FactoryGirl.create(:published_certificate_with_dataset)
      end

      Delayed::Job.expects(:enqueue).with(UploadUsageData, has_entries(priority: 5))

      UploadUsageData.perform

      collection = UploadUsageData.find_collection(ENV['GAPPS_CERTIFICATE_USAGE_COLLECTION'] || '')

      published_certificates = collection.files.select {|f| f.title.match /Published certificates - [0-9]+\-[0-9]+\-[0-9]+/}
      all_certificates = collection.files.select {|f| f.title.match /All certificates - [0-9]+\-[0-9]+\-[0-9]+/}

      assert_equal 1, published_certificates.count
      assert_equal 1, all_certificates.count
    end
  end

end
