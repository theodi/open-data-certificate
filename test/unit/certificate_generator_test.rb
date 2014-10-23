require 'test_helper'

class CertificateGeneratorTest < ActiveSupport::TestCase

  def setup
    load_custom_survey 'cert_generator.rb'
    @user = FactoryGirl.create :user
  end

  test "creating blank certificate" do
    load_custom_survey 'blank.rb'

    assert_difference 'Certificate.count', 1 do
      CertificateGenerator.create(request: {}, user: @user).generate('blank', false)

      certificate = Certificate.last

      assert certificate.published
      assert_equal 'blank', CertificateGenerator.last.survey.access_code
    end
  end

  test "creating certificate which auto publishes" do

    dataset = {
      dataTitle: 'The title',
      releaseType: 'oneoff',
      publisherUrl: 'http://www.example.com',
      publisherRights: 'yes',
      publisherOrigin: 'true',
      linkedTo: 'true',
      chooseAny: ['one', 'two']
    }

    assert_difference 'Certificate.count', 1 do
      generator = CertificateGenerator.create(request: dataset, user: @user).generate('cert-generator', false)

      assert CertificateGenerator.last.completed

      certificate = Certificate.last

      assert certificate.published
      assert_equal 1, Certificate.count
    end
  end

  test "creating certificate with missing field" do

    dataset = {
      releaseType: 'oneoff',
      publisherUrl: 'http://www.example.com',
      publisherRights: 'yes',
      publisherOrigin: 'true',
      linkedTo: 'true',
      chooseAny: ['one', 'two']
    }

    assert_difference 'Certificate.count', 1 do
      CertificateGenerator.create(request: dataset, user: @user).generate('cert-generator', false)

      certificate = Certificate.last

      refute certificate.published
    end
  end

  test "creating certificate with invalid URL" do
    stub_request(:get, "http://www.example/error").
                to_return(:body => "", status: 404)

    dataset = {
      dataTitle: 'The title',
      releaseType: 'oneoff',
      publisherUrl: 'http://www.example/error',
      publisherRights: 'yes',
      publisherOrigin: 'true',
      linkedTo: 'true',
      chooseAny: ['one', 'two']
    }

    assert_difference 'Certificate.count', 1 do
      CertificateGenerator.create(request: dataset, user: @user).generate('cert-generator', false)

      refute Certificate.last.published
    end
  end

  test "publishing a certificate after creating and updating it" do

    create = {
      dataTitle: 'The title',
      releaseType: 'oneoff',
      publisherRights: 'yes',
      publisherOrigin: 'true',
      linkedTo: 'true',
    }

    update = {
      publisherUrl: 'http://www.example.com',
      publisherRights: 'yes',
      publisherOrigin: 'true',
      linkedTo: 'true',
      chooseAny: ['one', 'two']
    }

    assert_difference 'ResponseSet.count', 1 do
      CertificateGenerator.create(request: create, user: @user).generate('cert-generator', false)
      refute Certificate.last.published
    end

    assert_no_difference 'ResponseSet.count' do
      response = CertificateGenerator.update(Dataset.last, update, 'cert-generator', @user)
      assert_equal(true, response[:success])
      assert_equal(true, response[:published])
      assert_equal([], response[:errors])
    end
  end

  test "updating a certificate with a missing field" do

    create = {
      dataTitle: 'The title',
      releaseType: 'oneoff',
      publisherUrl: 'http://www.example.com',
      publisherRights: 'yes',
      publisherOrigin: 'true',
      linkedTo: 'true',
      chooseAny: ['one', 'two']
    }

    update = {
      dataTitle: 'The title',
      releaseType: 'oneoff',
      publisherRights: 'yes',
      publisherUrl: '',
      publisherOrigin: 'true',
      linkedTo: 'true',
      chooseAny: ['one', 'two']
    }

    assert_difference 'ResponseSet.count', 1 do
      CertificateGenerator.create(request: create, user: @user).generate('cert-generator', false)
      assert Certificate.last.published
    end

    assert_difference 'ResponseSet.count', 1 do
      response = CertificateGenerator.update(Dataset.last, update, 'cert-generator', @user)
      assert_equal(true, response[:success])
      assert_equal(false, response[:published])
      assert_equal(["The question 'publisherUrl' is mandatory"], response[:errors])
    end

    assert_no_difference 'ResponseSet.count' do
      response = CertificateGenerator.update(Dataset.last, update, 'cert-generator', @user)
      assert_equal(true, response[:success])
      assert_equal(false, response[:published])
      assert_equal(["The question 'publisherUrl' is mandatory"], response[:errors])
    end
  end

  test "updating a certificate after the survey has been updated" do

      create = {
        dataTitle: 'The title',
        releaseType: 'oneoff',
        publisherUrl: 'http://www.example.com',
        publisherRights: 'yes',
        publisherOrigin: 'true',
        linkedTo: 'true',
        chooseAny: ['one', 'two']
      }

      update = {
        dataTitle: 'The title 2',
      }

      assert_difference 'ResponseSet.count', 1 do
        CertificateGenerator.create(request: create, user: @user).generate('cert-generator', false)
        assert Certificate.last.published
      end

      assert_difference 'Survey.count', 1 do
        load_custom_survey 'cert_generator_updated.rb'
      end

      assert_difference 'ResponseSet.count', 1 do
        response = CertificateGenerator.update(Dataset.last, update, 'cert-generator', @user)
        assert_equal(true, response[:success])
        assert_equal(false, response[:published])
        assert_equal(["The question 'favouriteAnimal' is mandatory"], response[:errors])
      end
    end

end
