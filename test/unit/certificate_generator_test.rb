require 'test_helper'

class CertificateGeneratorTest < ActiveSupport::TestCase

  def setup
    @user = FactoryGirl.create :user
  end

  test "creating blank certificate" do
    load_custom_survey 'blank.rb'

    request = {
      jurisdiction: 'blank'
    }

    assert_difference 'Certificate.count', 1 do
      response = CertificateGenerator.generate(request, @user)
      assert_equal(true, response[:success])
      assert_equal(true, response[:published])
      assert_equal([], response[:errors])
      assert_equal('blank', CertificateGenerator.last.survey.access_code)
    end
  end

  test "creating certificate which auto publishes" do
    load_custom_survey 'cert_generator.rb'

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
      response = CertificateGenerator.generate(request, @user)
      assert_equal(true, response[:success])
      assert_equal(true, response[:published])
      assert_equal([], response[:errors])
    end
  end

  test "creating certificate with missing field" do
    load_custom_survey 'cert_generator.rb'

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
      response = CertificateGenerator.generate(request, @user)
      assert_equal(true, response[:success])
      assert_equal(false, response[:published])
      assert_equal(["The question 'dataTitle' is mandatory"], response[:errors])
    end
  end

  test "creating certificate with invalid URL" do
    stub_request(:get, "http://www.example/error").
                to_return(:body => "", status: 404)

    load_custom_survey 'cert_generator.rb'

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
      response = CertificateGenerator.generate(request, @user)
      assert_equal(true, response[:success])
      assert_equal(false, response[:published])
      assert_equal(["The question 'publisherUrl' must have a valid URL"], response[:errors])
    end
  end

  test "unknown jurisdiction" do
    request = {jurisdiction: 'non-existant'}
    response = CertificateGenerator.generate(request, @user)
    assert_equal(false, response[:success])
    assert_equal(["Jurisdiction not found"], response[:errors])
  end

  test "publishing a certificate after creating and updating it" do
    load_custom_survey 'cert_generator.rb'

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
      response = CertificateGenerator.generate(create, @user)
      assert_equal(true, response[:success])
      assert_equal(false, response[:published])
      assert_equal(["The question 'publisherUrl' is mandatory", "The question 'chooseAny' is mandatory"], response[:errors])
    end

    assert_no_difference 'ResponseSet.count' do
      response = CertificateGenerator.update(Dataset.last, update, @user)
      assert_equal(true, response[:success])
      assert_equal(true, response[:published])
      assert_equal([], response[:errors])
    end
  end

  test "updating a certificate with a missing field" do
    load_custom_survey 'cert_generator.rb'

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
      response = CertificateGenerator.generate(create, @user)
      assert_equal(true, response[:success])
      assert_equal(true, response[:published])
      assert_equal([], response[:errors])
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
    load_custom_survey 'cert_generator.rb'

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

    response = nil

    assert_difference 'ResponseSet.count', 1 do
      response = CertificateGenerator.generate(create, @user)
      assert_equal(true, response[:success])
      assert_equal(true, response[:published])
      assert_equal([], response[:errors])
    end

    assert_difference 'Survey.count', 1 do
      load_custom_survey 'cert_generator_updated.rb'
    end

    assert_difference 'ResponseSet.count', 1 do
      response = CertificateGenerator.update(Dataset.find(response[:dataset_id]), update, @user)
      assert_equal(true, response[:success])
      assert_equal(false, response[:published])
      assert_equal(["The question 'favouriteAnimal' is mandatory"], response[:errors])
    end
  end

  # test "target_email" do
  #   load_custom_survey 'blank.rb'
  #   request = {
  #     jurisdiction: 'blank'
  #   }
  #   generator = CertificateGenerator.new request: request
  #   assert_difference 'Certificate.count', 1 do
  #     generator.generate
  #   end
  # end

private

  def load_custom_survey fname
    builder = SurveyBuilder.new 'test/fixtures/surveys_custom', fname
    builder.parse_file
  end

end
