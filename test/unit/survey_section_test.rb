require_relative '../test_helper'

class SurveySectionTest < ActiveSupport::TestCase

  def setup
    @section = FactoryGirl.create :survey_section

    # add two questions, one to be the certificate
    @q1 = FactoryGirl.create :question,                survey_section: @section
    @q2 = FactoryGirl.create :question_on_certificate, survey_section: @section

    @response_set = FactoryGirl.create :response_set

  end


  test "questions_for_certificate gives questions with :question_on_certificate" do

    @questions = @section.questions_for_certificate @response_set

    assert_equal [@q2], @questions

  end

  # TODO
  # test "questions_for_certificate selects only triggered questions"

end