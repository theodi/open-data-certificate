require 'test_helper'

class CertificateGeneratorTest < ActiveSupport::TestCase

  test "creating blank certificate" do
    load_custom_survey 'blank.rb'

    request = {
      jurisdiction: 'blank'
    }

    assert_difference 'Certificate.count', 1 do
      response = CertificateGenerator.generate(request)
      assert_equal({success: true, published: true, errors: []}, response)
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
      response = CertificateGenerator.generate(request)
      assert_equal({success: true, published: true, errors: []}, response)
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
      response = CertificateGenerator.generate(request)
      assert_equal({success: true, published: false, errors: ["The question 'dataTitle' is mandatory"]}, response)
    end
  end

  test "creating certificate with invalid URL" do
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
      response = CertificateGenerator.generate(request)
      assert_equal({success: true, published: false, errors: ["The question 'publisherUrl' must have a valid URL"]}, response)
    end
  end

  test "unknown jurisdiction" do
    response = CertificateGenerator.generate({jurisdiction: 'non-existant'})
    assert_equal({success: false, errors: ["Jurisdiction not found"]}, response)
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
