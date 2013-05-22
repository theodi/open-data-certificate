require 'test_helper'

class ResponseSetTest < ActiveSupport::TestCase

  test "creating a response set does not a certificate" do
    assert_no_difference "Certificate.count" do
      FactoryGirl.create :response_set
    end
  end

  test "completing a response set creates a certificate" do
    assert_difference "Certificate.count" do
      FactoryGirl.create :completed_response_set
    end
  end

  test "created certificate is given the attained_level" do
    @rs = FactoryGirl.create :completed_response_set
    assert_equal @rs.certificate.attained_level, @rs.attained_level
  end

  test "can map questions to responses" do

    # add two questions, one to be the certificate
    @q1 = FactoryGirl.create :question
    @a1 = FactoryGirl.create :answer, question: @q1

    @response_set = FactoryGirl.create :response_set

    # answer the questions
    @response_1 = FactoryGirl.create :response, response_set: @response_set, 
                                     :question => @q1, :answer => @a1 


    @responses = @response_set.responses_for_questions [@q1]

    assert_equal [@response_1], @responses

  end

end