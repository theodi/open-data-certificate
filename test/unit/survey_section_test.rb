require 'test_helper'

class SurveySectionTest < ActiveSupport::TestCase

  def setup
    @section = FactoryGirl.create :survey_section

    # add two questions, one to be the certificate
    @q1 = FactoryGirl.create :question,                survey_section: @section
    @q2 = FactoryGirl.create :question_on_certificate, survey_section: @section

    @a1 = FactoryGirl.create :answer, question: @q1
    @a2 = FactoryGirl.create :answer, question: @q2

    @empty_response_set = FactoryGirl.create :response_set
    @full_response_set = FactoryGirl.create :response_set

    # answer the questions
    FactoryGirl.create :response, response_set: @full_response_set, :question => @q1, :answer => @a1 
    FactoryGirl.create :response, response_set: @full_response_set, :question => @q2, :answer => @a2 

  end

  test "no answers will display when none given" do
    @responses = @section.responses_for_certificate @empty_response_set

    assert_equal 0, @responses.size
  end

  test "retrieve questions with :question_on_certificate set" do
    @responses = @section.responses_for_certificate @full_response_set

    # only one of the questions has :question_on_certificate
    assert_equal 1, @responses.size
  end

  test "display questions with :question_on_certificate set to true" do
    assert_equal     false, @section.question_response_for_certificate(@q1, @full_response_set)
    assert_not_equal false, @section.question_response_for_certificate(@q2, @full_response_set)
  end

  test "display only triggered questions" do
    assert_equal false, @section.question_response_for_certificate(@q1, @full_response_set)
  end

end