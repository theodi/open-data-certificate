require 'test_helper'

class CertificateGeneratorTest < ActiveSupport::TestCase

  def setup
    load_custom_survey 'cert_generator.rb'
    @user = FactoryGirl.create :user
    @survey = Survey.newest_survey_for_access_code 'cert-generator'
  end

  test "calls generate" do
    load_custom_survey 'blank.rb'

    request = {
      jurisdiction: 'blank'
    }

    CertificateGenerator.any_instance.stubs(:delay).returns CertificateGenerator.new
    CertificateGenerator.any_instance.expects(:generate).once

    response = CertificateGenerator.generate(request, @user)
    assert_equal("pending", response[:success])
    assert_equal(Dataset.last.id, response[:dataset_id])
  end

  test "creating blank certificate" do
    load_custom_survey 'blank.rb'

    request = {
      jurisdiction: 'blank'
    }

    assert_difference 'Certificate.count', 1 do
      survey = Survey.newest_survey_for_access_code 'blank'
      CertificateGenerator.create(request: request, survey: survey, user: @user).generate(false)

      certificate = Certificate.last

      assert certificate.published
      assert_equal 'blank', CertificateGenerator.last.survey.access_code
    end
  end

  test "creating certificate which auto publishes" do

    request = {
      jurisdiction: 'cert-generator',
      dataset: {
        dataTitle: 'The title',
        releaseType: 'oneoff',
        publisherUrl: 'http://www.example.com',
        publisherRights: 'yes',
        publisherOrigin: 'true',
        linkedTo: 'true',
        chooseAny: ['one', 'two']
      }
    }

    assert_difference 'Certificate.count', 1 do
      CertificateGenerator.create(request: request, survey: @survey, user: @user).generate(false)

      certificate = Certificate.last

      assert certificate.published
      assert_equal 1, Certificate.count
    end
  end

  test "creating certificate with missing field" do

    request = {
      jurisdiction: 'cert-generator',
      dataset: {
        releaseType: 'oneoff',
        publisherUrl: 'http://www.example.com',
        publisherRights: 'yes',
        publisherOrigin: 'true',
        linkedTo: 'true',
        chooseAny: ['one', 'two']
      }
    }

    assert_difference 'Certificate.count', 1 do
      CertificateGenerator.create(request: request, survey: @survey, user: @user).generate(false)

      certificate = Certificate.last

      refute certificate.published
    end
  end

  test "creating certificate with invalid URL" do
    stub_request(:get, "http://www.example/error").
                to_return(:body => "", status: 404)

    request = {
      jurisdiction: 'cert-generator',
      dataset: {
        dataTitle: 'The title',
        releaseType: 'oneoff',
        publisherUrl: 'http://www.example/error',
        publisherRights: 'yes',
        publisherOrigin: 'true',
        linkedTo: 'true',
        chooseAny: ['one', 'two']
      }
    }

    assert_difference 'Certificate.count', 1 do
      CertificateGenerator.create(request: request, survey: @survey, user: @user).generate(false)

      refute Certificate.last.published
    end
  end

  test "unknown jurisdiction" do
    request = {jurisdiction: 'non-existant'}
    response = CertificateGenerator.generate(request, @user)
    assert_equal(false, response[:success])
    assert_equal(["Jurisdiction not found"], response[:errors])
  end

  test "publishing a certificate after creating and updating it" do

    create = {
      jurisdiction: 'cert-generator',
      dataset: {
        dataTitle: 'The title',
        releaseType: 'oneoff',
        publisherRights: 'yes',
        publisherOrigin: 'true',
        linkedTo: 'true',
      }
    }

    update = {
      jurisdiction: 'cert-generator',
      dataset: {
        publisherUrl: 'http://www.example.com',
        publisherRights: 'yes',
        publisherOrigin: 'true',
        linkedTo: 'true',
        chooseAny: ['one', 'two']
      }
    }

    assert_difference 'ResponseSet.count', 1 do
      CertificateGenerator.create(request: create, survey: @survey, user: @user).generate(false)
      refute Certificate.last.published
    end

    assert_no_difference 'ResponseSet.count' do
      response = CertificateGenerator.update(Dataset.last, update, @user)
      assert_equal(true, response[:success])
      assert_equal(true, response[:published])
      assert_equal([], response[:errors])
    end
  end

  test "updating a certificate with a missing field" do

    create = {
      jurisdiction: 'cert-generator',
      dataset: {
        dataTitle: 'The title',
        releaseType: 'oneoff',
        publisherUrl: 'http://www.example.com',
        publisherRights: 'yes',
        publisherOrigin: 'true',
        linkedTo: 'true',
        chooseAny: ['one', 'two']
      }
    }

    update = {
      jurisdiction: 'cert-generator',
      dataset: {
        dataTitle: 'The title',
        releaseType: 'oneoff',
        publisherRights: 'yes',
        publisherUrl: '',
        publisherOrigin: 'true',
        linkedTo: 'true',
        chooseAny: ['one', 'two']
      }
    }

    assert_difference 'ResponseSet.count', 1 do
      CertificateGenerator.create(request: create, survey: @survey, user: @user).generate(false)
      assert Certificate.last.published
    end

    assert_difference 'ResponseSet.count', 1 do
      response = CertificateGenerator.update(Dataset.last, update, @user)
      assert_equal(true, response[:success])
      assert_equal(false, response[:published])
      assert_equal(["The question 'publisherUrl' is mandatory"], response[:errors])
    end

    assert_no_difference 'ResponseSet.count' do
      response = CertificateGenerator.update(Dataset.last, update, @user)
      assert_equal(true, response[:success])
      assert_equal(false, response[:published])
      assert_equal(["The question 'publisherUrl' is mandatory"], response[:errors])
    end
  end

  test "updating a certificate after the survey has been updated" do

      create = {
        jurisdiction: 'cert-generator',
        dataset: {
          dataTitle: 'The title',
          releaseType: 'oneoff',
          publisherUrl: 'http://www.example.com',
          publisherRights: 'yes',
          publisherOrigin: 'true',
          linkedTo: 'true',
          chooseAny: ['one', 'two']
        }
      }

      update = {
        jurisdiction: 'cert-generator',
        dataset: {
          dataTitle: 'The title 2',
        }
      }

      assert_difference 'ResponseSet.count', 1 do
        CertificateGenerator.create(request: create, survey: @survey, user: @user).generate(false)
        assert Certificate.last.published
      end

      assert_difference 'Survey.count', 1 do
        load_custom_survey 'cert_generator_updated.rb'
      end

      assert_difference 'ResponseSet.count', 1 do
        response = CertificateGenerator.update(Dataset.last, update, @user)
        assert_equal(true, response[:success])
        assert_equal(false, response[:published])
        assert_equal(["The question 'favouriteAnimal' is mandatory"], response[:errors])
      end
    end

end
