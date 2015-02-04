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

  test "url validations" do
    bot = ODIBot.new("http://valid.com")
    ODIBot.stubs(:new).returns(bot)
    bot.stubs(:valid?).returns(false)
    url_answer = FactoryGirl.create(:answer, input_type: 'url')
    response = FactoryGirl.create(:response, string_value: "foo bar", question: @question, answer: url_answer)
    assert response.error

    bot.stubs(:valid?).returns(true)
    response.update_attributes(string_value: "http://example.org")
    refute response.error
  end

  test "url validation passes with blank value" do
    ODIBot.expects(:new).never
    url_answer = FactoryGirl.create(:answer, input_type: 'url')
    response = FactoryGirl.create(:response, string_value: "", question: @question, answer: url_answer)
    refute response.error
  end

  test "valid if url valid" do
    ODIBot.stubs(:new).returns(stub(:valid? => true))
    url_answer = FactoryGirl.create(:answer, input_type: 'url')
    response = FactoryGirl.create(:response, string_value: "http://example.com", question: @question, answer: url_answer)
    assert response.url_valid_or_explained?
  end

  test "invalid if url invalid" do
    ODIBot.stubs(:new).returns(stub(:valid? => false))
    url_answer = FactoryGirl.create(:answer, input_type: 'url')
    response = FactoryGirl.create(:response, string_value: "http://example.com", question: @question, answer: url_answer)
    refute response.url_valid_or_explained?
  end

  test "valid if url invalid but explained" do
    ODIBot.stubs(:new).returns(stub(:valid? => false))
    url_answer = FactoryGirl.create(:answer, input_type: 'url')
    response = FactoryGirl.create(:response, string_value: "http://example.com", question: @question, answer: url_answer, explanation: "it's broken")
    assert response.url_valid_or_explained?
  end

end
