require 'test_helper'

class CertificateGeneratorTest < ActiveSupport::TestCase

  test "creating blank certificate" do
    load_custom_survey 'blank.rb'

    request = {
      jurisdiction: 'blank'
    }

    assert_difference 'Certificate.count', 1 do
      cg = CertificateGenerator.create request: request
      assert_equal cg.survey.access_code, 'blank'
    end

  end


  test "creating certificate with params" do
    load_custom_survey 'cert_generator.rb'

    request = {
      jurisdiction: 'cert-generator',
      dataset: {
        dataTitle: 'The title',
        releaseType: 'oneoff',
        publisherRights: 'yes',
        publisherOrigin: 'true',
        linkedTo: 'true',
        chooseAny: ['1', '3']
      }
    }

    assert_difference 'Certificate.count', 1 do
      CertificateGenerator.create request: request
    end
  end


  # test "unknown jurisdiction" do
  #   request = {
  #     jurisdiction: 'unknown'
  #   }
  #   generator = CertificateGenerator.create request: request
  #   assert generator.request_errors.include? 'Could not find survey'
  # end


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