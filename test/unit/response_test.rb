require 'test_helper'

class ResponseTest < ActiveSupport::TestCase

  def setup
    @question  = FactoryGirl.create :question
    @answer_1  = FactoryGirl.create :answer
    @answer_2  = FactoryGirl.create :answer, :text_as_statement => "yes he does"
    @response1 = FactoryGirl.create :response, question: @question, answer: @answer_1, :string_value => 'yes, I do'
    @response2 = FactoryGirl.create :response, question: @question, answer: @answer_2
  end

  test 'statement_text uses existing to_formatted_s' do
    assert_equal 'yes, I do', @response1.statement_text
  end

  test 'statement_text with answer.text_as_statement' do
    assert_equal 'yes he does', @response2.statement_text
  end

end
