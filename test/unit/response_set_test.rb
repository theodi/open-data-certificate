require_relative '../test_helper'

class ResponseSetTest < ActiveSupport::TestCase

  should belong_to(:dataset)
  should have_one(:certificate)

  test "creating a response set creates a certificate" do
    assert_difference "Certificate.count", 1 do
      FactoryGirl.create :response_set
    end
  end

  test "completing a response set creates a certificate" do
    assert_difference "Certificate.count" do
      FactoryGirl.create :completed_response_set
    end
  end

  test "created certificate is given the attained_level" do
    response_set = FactoryGirl.create :completed_response_set
    response_set.certificate.update_from_response_set
    assert_equal response_set.certificate.attained_level, response_set.attained_level
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

  test "Should be able to populate response_set answers from another response_set" do
    response_value = rand.to_s
    q=FactoryGirl.create(:question, reference_identifier: :question_identifier)
    a=FactoryGirl.create(:answer, reference_identifier: :answer_identifier, question: q)

    source_response_set = FactoryGirl.create(:response_set, survey: a.question.survey_section.survey)
    FactoryGirl.create :response, { response_set: source_response_set,
                                    string_value: response_value,
                                    answer_id: a.id,
                                    question_id: a.question.id }
    source_response_set.reload

    response_set = FactoryGirl.create :response_set, survey: source_response_set.survey
    response_set.reload

    response_set.copy_answers_from_response_set!(source_response_set)

    assert response_set.responses.first.try(:string_value) == response_value
  end

  test "copies urls from old string_value responses to newer text_value columns" do
    response_value = rand.to_s
    q=FactoryGirl.create(:question, reference_identifier: :question_identifier)
    a=FactoryGirl.create(:answer, reference_identifier: :answer_identifier, question: q, response_class: 'text')

    source_response_set = FactoryGirl.create(:response_set, survey: a.question.survey_section.survey)
    FactoryGirl.create :response, { response_set: source_response_set,
                                    string_value: response_value,
                                    answer_id: a.id,
                                    question_id: a.question.id }
    source_response_set.reload

    response_set = FactoryGirl.create :response_set, survey: source_response_set.survey
    response_set.reload

    response_set.copy_answers_from_response_set!(source_response_set)

    assert response_set.responses.first.try(:text_value) == response_value
  end

  test "copies explanations for responses along with answers" do
    q=FactoryGirl.create(:question, reference_identifier: :question_identifier)
    a=FactoryGirl.create(:answer, reference_identifier: :answer_identifier, question: q, input_type: 'url')

    source_response_set = FactoryGirl.create(:response_set, survey: a.question.survey_section.survey)
    FactoryGirl.create :response, { response_set: source_response_set,
                                    string_value: "example.org/fail",
                                    explanation: "can't even protocol",
                                    answer_id: a.id,
                                    question_id: a.question.id }
    source_response_set.reload

    response_set = FactoryGirl.create :response_set, survey: source_response_set.survey
    response_set.reload

    response_set.copy_answers_from_response_set!(source_response_set)

    response = response_set.responses.first
    assert response_set.responses.first.string_value == "example.org/fail"
    assert response_set.responses.first.explanation == "can't even protocol"
  end

  def prepare_response_set(response_value = "Foo bar")
    q=FactoryGirl.create(:question, reference_identifier: :question_identifier)
    a=FactoryGirl.create(:answer, reference_identifier: :answer_identifier, question: q)

    source_response_set = FactoryGirl.create(:response_set, survey: a.question.survey_section.survey)
    FactoryGirl.create :response, { response_set: source_response_set,
                                    string_value: response_value,
                                    answer_id: a.id,
                                    question_id: a.question.id }
    source_response_set.reload
    source_response_set
  end

  test "should create a new cloned response set" do
    response_value = rand.to_s
    source_response_set = prepare_response_set(response_value)

    response_set = nil
    assert_difference 'ResponseSet.count', 1 do
      response_set = ResponseSet.clone_response_set(source_response_set, "dataset_id" => source_response_set.dataset_id)
    end

    assert_equal response_value, response_set.responses.first.try(:string_value)
    assert_equal source_response_set.dataset, response_set.dataset
  end

  test "clone dataset with updated survey" do
    response_value = rand.to_s
    source_response_set = prepare_response_set(response_value)
    q=FactoryGirl.create(:question, reference_identifier: :question_identifier)
    a=FactoryGirl.create(:answer, reference_identifier: :answer_identifier, question: q)

    old_survey = source_response_set.survey
    new_survey = q.survey_section.survey
    new_survey.access_code = old_survey.access_code
    new_survey.survey_version = 1
    new_survey.save

    assert old_survey.superseded?, 'survey should be superseded'

    response_set = nil
    assert_difference 'ResponseSet.count', 1 do
      response_set = ResponseSet.clone_response_set(source_response_set,
        "dataset_id" => source_response_set.dataset_id,
        "survey_id" => new_survey.id)
    end

    assert_equal response_value, response_set.responses.first.try(:string_value)
    assert_equal source_response_set.dataset, response_set.dataset
    assert_equal new_survey, response_set.survey
  end

  test "should clone with kitten_data intact" do
    source_response_set = prepare_response_set
    source_response_set.kitten_data = KittenData.create(url: 'http://www.example.com')

    response_set = ResponseSet.clone_response_set(source_response_set)

    assert response_set.kitten_data.url == 'http://www.example.com'
    source_response_set.reload
    assert source_response_set.kitten_data.url == 'http://www.example.com'
  end

  test "should clone with extra attributes" do
    source_response_set = prepare_response_set
    response_set = ResponseSet.clone_response_set(source_response_set, {user_id: 123})

    assert response_set.user_id == 123
  end

  test "Should raise an error if populating response_set answers from another response_set when responses already exist" do
    response_value = rand.to_s
    q=FactoryGirl.create(:question, reference_identifier: :question_identifier)
    a=FactoryGirl.create(:answer, reference_identifier: :answer_identifier, question: q)

    source_response_set = FactoryGirl.create(:response_set, survey: a.question.survey_section.survey)
    FactoryGirl.create :response, { response_set: source_response_set,
                                    string_value: response_value,
                                    answer_id: a.id,
                                    question_id: a.question.id }
    source_response_set.reload

    response_set = FactoryGirl.create :response_set, survey: source_response_set.survey
    FactoryGirl.create :response, { response_set: response_set,
                                    string_value: 'my response',
                                    answer_id: a.id,
                                    question_id: a.question.id }
    response_set.reload

    exception = assert_raise(RuntimeError) do
      response_set.copy_answers_from_response_set!(source_response_set)
    end

    assert_equal('Attempt to over-write existing responses.', exception.message)
  end


  test "Should be able to populate response_set answers from another response_set even if the surveys are different" do
    response_value = rand.to_s
    q1=FactoryGirl.create(:question, reference_identifier: :question_identifier)
    q2=FactoryGirl.create(:question, reference_identifier: :question_identifier)

    a1=FactoryGirl.create(:answer, reference_identifier: :answer_identifier, question: q1)
    a2=FactoryGirl.create(:answer, reference_identifier: :answer_identifier, question: q2)

    source_response_set = FactoryGirl.create(:response_set, survey: a1.question.survey_section.survey)
    FactoryGirl.create :response, { response_set: source_response_set,
                                    string_value: response_value,
                                    answer_id: a1.id,
                                    question_id: a1.question.id }
    source_response_set.reload

    response_set = FactoryGirl.create :response_set, survey: a2.question.survey_section.survey
    response_set.reload
    response_set.copy_answers_from_response_set!(source_response_set)

    assert response_set.responses.first.try(:string_value) == response_value
  end

  test "#triggered_mandatory_questions should return an array of all the mandatory questions that are triggered by their dependencies for the response_set" do
    # non-mandatory question
    question = FactoryGirl.create(:question, required: nil)

    survey_section = question.survey_section
    survey = survey_section.survey

    # mandatory question, but not triggered
    mandatory_question = FactoryGirl.create(:question, required: 'required', survey_section: survey_section)
    dependency = FactoryGirl.create(:dependency, question: mandatory_question)
    FactoryGirl.create :dependency_condition, dependency: dependency, operator: 'count>2'

    # triggered mandatory question
    triggered_mandatory_question = FactoryGirl.create(:question, required: 'required', survey_section: survey_section)
    survey.reload

    response_set = FactoryGirl.create(:response_set, survey: survey)

    assert_equal response_set.triggered_mandatory_questions, [triggered_mandatory_question]
  end

  test "#attained_level returns the correct string for the level achieved" do
    %w(none basic pilot standard exemplar).each_with_index do |level, i|
      response_set = FactoryGirl.create(:response_set)
      response_set.stubs(:minimum_outstanding_requirement_level).returns(i+1)
      assert_equal response_set.attained_level, level
    end
  end

  test "#minimum_outstanding_requirement_level returns correct value" do
    requirements = []
    Hash[*%w(5 exemplar 4 standard 3 pilot 2 basic 1 none)].each do |k, v|
      response_set = FactoryGirl.create(:response_set)
      requirements << stub(requirement_level_index: k.to_i)
      response_set.stubs(:outstanding_requirements).returns(requirements)
      assert_equal response_set.minimum_outstanding_requirement_level, k.to_i
    end
  end

  test "#minimum_outstanding_requirement_level returns exemplar index if there's no outstanding requirements" do
    response_set = FactoryGirl.create(:response_set)
    assert_equal response_set.minimum_outstanding_requirement_level, 5
  end

  test "#outstanding_requirements returns only triggered_requirements that are not met by responses" do
    triggered_requirements = [stub(requirement_met_by_responses?: true),
                              stub(requirement_met_by_responses?: true),
                              stub(requirement_met_by_responses?: true),
                              stub(requirement_met_by_responses?: false),
    ]

    response_set = FactoryGirl.create(:response_set)
    response_set.stubs(:triggered_requirements).returns(triggered_requirements)

    assert_equal [triggered_requirements.last], response_set.outstanding_requirements
  end

  test "#dataset_title_determined_from_responses returns the answer of the response to the question referenced as 'dataTitle'" do
    question = FactoryGirl.create(:question, reference_identifier: 'testDataTitle')
    answer = FactoryGirl.create(:answer, question: question)
    expected_value = 'my response set title'
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
    response = FactoryGirl.create(:response, response_set: response_set, string_value: expected_value, question: question, answer: answer)

    assert_equal expected_value, response_set.dataset_title_determined_from_responses
  end

  test "#title returns the title determined from the responses if there is one" do
    question = FactoryGirl.create(:question, reference_identifier: 'testDataTitle')
    answer = FactoryGirl.create(:answer, question: question)
    expected_value = 'my response set title'
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
    response = FactoryGirl.create(:response, response_set: response_set, string_value: expected_value, question: question, answer: answer)

    assert_equal expected_value, response_set.title
  end

  test "#title returns the default title if it cannot be determined from the responses" do
    expected_value = ResponseSet::DEFAULT_TITLE
    response_set = FactoryGirl.create(:response_set)

    assert_equal expected_value, response_set.title
  end

  test "#dataset_curator_determined_from_responses returns the answer of the response to the question referenced as 'publisher'" do
    question = FactoryGirl.create(:question, reference_identifier: 'testPublisher')
    answer = FactoryGirl.create(:answer, question: question)
    expected_value = 'my curator'
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
    response = FactoryGirl.create(:response, response_set: response_set, string_value: expected_value, question: question, answer: answer)

    assert_equal expected_value, response_set.dataset_curator_determined_from_responses
  end

  test "#dataset_documentation_url_determined_from_responses returns the answer of the response to the question referenced as 'documentationUrl'" do
    question = FactoryGirl.create(:question, reference_identifier: 'testDocumentationUrl')
    answer = FactoryGirl.create(:answer, question: question)
    expected_value = 'http://example.com'
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
    response = FactoryGirl.create(:response, response_set: response_set, string_value: expected_value, question: question, answer: answer)

    assert_equal expected_value, response_set.dataset_documentation_url_determined_from_responses
  end

  test "#data_licence_determined_from_responses returns 'Not applicable' when the data licence is not applicable" do
    question = FactoryGirl.create(:question, reference_identifier: 'dataLicence')
    answer = FactoryGirl.create(:answer, question: question, reference_identifier: "na")
    expected_value = {
      :title => "Not Applicable",
      :url => nil
    }
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
    response = FactoryGirl.create(:response, response_set: response_set, question: question, answer: answer)

    assert_equal expected_value, response_set.data_licence_determined_from_responses
  end

  test "#content_licence_determined_from_responses returns 'Not applicable' when the content licence is not applicable" do
    question = FactoryGirl.create(:question, reference_identifier: 'contentLicence')
    answer = FactoryGirl.create(:answer, question: question, reference_identifier: "na")
    expected_value = {
      :title => "Not Applicable",
      :url => nil
    }
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
    response = FactoryGirl.create(:response, response_set: response_set, question: question, answer: answer)

    assert_equal expected_value, response_set.content_licence_determined_from_responses
  end

  %w[data_licence content_licence].each do |licence_type|
    test "##{licence_type}_determined_from_responses returns the correct responses when question has standard answer" do
      question = FactoryGirl.create(:question, reference_identifier: licence_type.camelize(:lower))
      answer = FactoryGirl.create(:answer, question: question, reference_identifier: 'licence-id', text: 'Licence Title', response_class: 'answer')
      response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
      response = FactoryGirl.create(:response, response_set: response_set, question: question, answer: answer)

      expected_value = {
        title: 'Licence Title',
        url: nil
      }
      method_name = :"#{licence_type}_determined_from_responses"

      assert_equal expected_value, response_set.send(method_name)
    end
  end

  test "#data_licence_determined_from_responses returns the correct response when the data licence is a non-standard licence" do
    other_data_name_question = FactoryGirl.create(:question, reference_identifier: 'otherDataLicenceName')
    other_data_name_answer = FactoryGirl.create(:answer, question: other_data_name_question)
    other_data_name = 'A made up licence'

    other_data_url_question = FactoryGirl.create(:question, reference_identifier: 'otherDataLicenceURL')
    other_data_url_answer = FactoryGirl.create(:answer, question: other_data_url_question)
    other_data_url = 'http://www.example.com/id/made-up-licence'

    question = FactoryGirl.create(:question, reference_identifier: 'dataLicence')
    answer = FactoryGirl.create(:answer, question: question, reference_identifier: "other")
    expected_value = {
      :title => other_data_name,
      :url => other_data_url
    }
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
    response = FactoryGirl.create(:response, response_set: response_set, question: question, answer: answer)
    other_data_name_response = FactoryGirl.create(:response, response_set: response_set, string_value: other_data_name, question: other_data_name_question, answer: other_data_name_answer)
    other_data_url_response = FactoryGirl.create(:response, response_set: response_set, string_value: other_data_url, question: other_data_url_question, answer: other_data_url_answer)

    assert_equal expected_value, response_set.data_licence_determined_from_responses
  end

  test "#licences returns both data and content licences" do
    rs = FactoryGirl.create(:response_set)
    rs.stubs(:data_licence_determined_from_responses).returns({title:"data"})
    rs.stubs(:content_licence_determined_from_responses).returns({title:"content"})

    expected = {
      data:    {title: "data"},
      content: {title: "content"}
    }

    assert_equal expected, rs.licences
  end

  test "#incomplete? returns true for an incomplete response_set" do
    assert_equal true, FactoryGirl.build(:response_set).incomplete?
  end

  test "#incomplete? returns false for an complete response_set" do
    assert_equal false, FactoryGirl.build(:completed_response_set).incomplete?
  end

  test "#generate_certificate creates a new certificate on save of completed response_sets" do
    response_set = FactoryGirl.build(:completed_response_set)
    assert_nil response_set.certificate
    response_set.save!
    assert_not_nil response_set.certificate
  end

  test "#generate_certificate does not overwrite existing certificate" do
    response_set = FactoryGirl.create(:completed_response_set)
    assert_not_nil certificate = response_set.certificate
    response_set.update_certificate
    assert_equal certificate, response_set.certificate
  end

  test "Should be able to assign_to_user" do
    response_set = FactoryGirl.create(:response_set, user: nil)
    user = FactoryGirl.create(:user)
    assert response_set.user.nil?
    response_set.assign_to_user!(user)

    assert_equal user, response_set.user
    assert_equal user, response_set.dataset.user
    assert_not_nil response_set.dataset
  end

  test "#newest_in_dataset? returns true for the most recent response_set" do
    dataset = FactoryGirl.build(:dataset)
    FactoryGirl.create(:response_set, dataset: dataset, created_at: Time.now.ago(1.hour))
    response_set = FactoryGirl.create(:response_set, dataset: dataset, created_at: Time.now)
    FactoryGirl.create(:response_set, dataset: dataset, created_at: Time.now.ago(3.hour))
    FactoryGirl.create(:response_set, dataset: dataset, created_at: Time.now.ago(2.hour))
    dataset.reload

    assert response_set.newest_in_dataset?
  end

  test "#newest_in_dataset? returns false when not the most recent response_set" do
    dataset = FactoryGirl.build(:dataset)
    response_set1 = FactoryGirl.create(:response_set, dataset: dataset, created_at: Time.now.ago(1.hour))
    FactoryGirl.create(:response_set, dataset: dataset, created_at: Time.now)
    response_set2 = FactoryGirl.create(:response_set, dataset: dataset, created_at: Time.now.ago(3.hour))
    response_set3 = FactoryGirl.create(:response_set, dataset: dataset, created_at: Time.now.ago(2.hour))
    dataset.reload

    [response_set1, response_set2, response_set3].each do |response_set|
      assert_false response_set.newest_in_dataset?
    end
  end

  test "#newest_completed_in_dataset? returns true for the most recent completed response_set" do
    dataset = FactoryGirl.build(:dataset)
    FactoryGirl.create(:response_set, dataset: dataset, created_at: Time.now.ago(1.hour))
    FactoryGirl.create(:response_set, dataset: dataset, created_at: Time.now.ago(3.hour))
    FactoryGirl.create(:completed_response_set, dataset: dataset, created_at: Time.now.ago(4.hour))
    FactoryGirl.create(:completed_response_set, dataset: dataset, created_at: Time.now.ago(2.hour))
    response_set = FactoryGirl.create(:completed_response_set, dataset: dataset, created_at: Time.now.ago(5.minutes))
    FactoryGirl.create(:response_set, dataset: dataset, created_at: Time.now.ago(1.minute))
    dataset.reload

    assert response_set.newest_completed_in_dataset?
  end

  test "#newest_completed_in_dataset? returns false when not the most recent completed response_set" do
    dataset = FactoryGirl.build(:dataset)
    response_set1 = FactoryGirl.create(:response_set, dataset: dataset, created_at: Time.now.ago(1.hour))
    response_set2 = FactoryGirl.create(:response_set, dataset: dataset, created_at: Time.now.ago(3.hour))
    response_set3 = FactoryGirl.create(:completed_response_set, dataset: dataset, created_at: Time.now.ago(4.hour))
    response_set4 = FactoryGirl.create(:completed_response_set, dataset: dataset, created_at: Time.now.ago(2.hour))
    FactoryGirl.create(:completed_response_set, dataset: dataset, created_at: Time.now.ago(5.minutes))
    response_set5 = FactoryGirl.create(:response_set, dataset: dataset, created_at: Time.now.ago(1.minute))
    dataset.reload

    [response_set1, response_set2, response_set3, response_set4, response_set5].each_with_index do |response_set, i|
      assert_false response_set.newest_completed_in_dataset?, "response_set#{i+1} failed assertion - created_at: #{response_set.created_at}"
    end
  end


  ### stateful things

  test "publishing a response_set published the certificate" do
    response_set = FactoryGirl.create(:response_set)

    assert_false response_set.certificate.published, "certificate starts unpublished"

    response_set.publish

    assert response_set.certificate.published, "certificate was published"
  end

  test "can't publish an unpublishable response_set" do

    # mandatory question
    question = FactoryGirl.create(:question, required: 'required')
    survey_section = question.survey_section
    survey = survey_section.survey

    # which was not answered
    response_set = FactoryGirl.create(:response_set, survey: survey)

    assert !response_set.may_publish?

  end

  test "publishing a certificate populates the attained_index" do
    response_set = FactoryGirl.create(:response_set)

    assert_equal nil, response_set.attained_index

    response_set.publish!

    assert_not_equal nil, response_set.attained_index
  end

  test "all urls resolve returns true if all urls resolve sucessfully" do
    response_set = FactoryGirl.create(:response_set)


    ODIBot.stubs(:new).returns(stub(:valid? => true))
    5.times do |n|
      question = FactoryGirl.create(:question, reference_identifier: "url_#{n}")
      answer = FactoryGirl.create(:answer, question: question, input_type: "url", )
      response = FactoryGirl.create(:response, response_set: response_set, question: question, answer: answer, string_value: "http://www.example.com/success")
    end

    assert response_set.all_urls_resolve?
  end

  test "all urls resolve returns false if some urls resolve unsucessfully" do
    response_set = FactoryGirl.create(:response_set)

    ODIBot.stubs(:new).with("http://www.example.com/success").returns(stub(:valid? => true))
    ODIBot.stubs(:new).with("http://www.example.com/fail").returns(stub(:valid? => false))
    2.times do |n|
      question = FactoryGirl.create(:question, reference_identifier: "url_#{n}")
      answer = FactoryGirl.create(:answer, question: question, input_type: "url", )
      response = FactoryGirl.create(:response, response_set: response_set, question: question, answer: answer, string_value: "http://www.example.com/success")
    end

    2.times do |n|
      question = FactoryGirl.create(:question, reference_identifier: "url_#{n}")
      answer = FactoryGirl.create(:answer, question: question, input_type: "url", )
      response = FactoryGirl.create(:response, response_set: response_set, question: question, answer: answer, string_value: "http://www.example.com/fail")
    end

    refute response_set.all_urls_resolve?
  end

  test "all urls resolve returns true if an explanation given" do
    response_set = FactoryGirl.create(:response_set)

    ODIBot.stubs(:new).with("http://www.example.com/fail").returns(stub(:valid? => false))

    question = FactoryGirl.create(:question, reference_identifier: "url")
    answer = FactoryGirl.create(:answer, question: question, input_type: "url", )
    response = FactoryGirl.create(:response, response_set: response_set, question: question, answer: answer, string_value: "http://www.example.com/fail", explanation: "is not blank")

    assert response_set.all_urls_resolve?
  end

  test "progress calculation of response_set" do
    response_set = FactoryGirl.create(:response_set)
    progress = response_set.progress

    assert_equal 0, progress['basic']
    assert_equal 0, progress['pilot']
    assert_equal 0, progress['standard']
    assert_equal 0, progress['exemplar']
    assert_equal 'exemplar', progress['attained']
  end

  test "calculating missing responses for when autogenerated" do
    question = FactoryGirl.create(:question, required: nil)

    survey_section = question.survey_section
    survey = survey_section.survey

    mandatory_question_1 = FactoryGirl.create(:question, required: 'required', survey_section: survey_section)
    mandatory_question_2 = FactoryGirl.create(:question, required: 'required', survey_section: survey_section)

    survey.reload

    response_set = FactoryGirl.create(:autogenerated_response_set, survey: survey)
    response_set.update_missing_responses!

    assert_equal "#{mandatory_question_1.text},#{mandatory_question_2.text}", response_set.missing_responses
  end

end

class ResponseSetErrorsTest < ActiveSupport::TestCase
  def setup
    load_custom_survey 'cert_generator.rb'
    @user = FactoryGirl.create :user
  end

  test "a missing answer causes an error" do
    survey = Survey.newest_survey_for_access_code('cert-generator')
    rs = ResponseSet.create!(:survey => survey)

    assert_equal %w[mandatory], rs.response_errors['publisherUrl']
  end

  test "an unresolvable url causes an error" do
    odibot = mock('odibot')
    odibot.stubs(:valid?).returns(false)
    ODIBot.expects(:new).at_least_once.with('http://invalid.com').returns(odibot)
    survey = Survey.newest_survey_for_access_code('cert-generator')
    rs = ResponseSet.create!(:survey => survey)
    rs.update_responses('documentationUrl' => 'http://invalid.com')

    assert rs.response_errors['documentationUrl'].include?('invalid-url'), 'url is marked as invalid'
  end

  test "an unresolvable url causes an error for a mandatory question" do
    odibot = mock('odibot')
    odibot.stubs(:valid?).returns(false)
    ODIBot.expects(:new).at_least_once.with('http://invalid.com').returns(odibot)
    survey = Survey.newest_survey_for_access_code('cert-generator')
    rs = ResponseSet.create!(:survey => survey)
    rs.update_responses('publisherUrl' => 'http://invalid.com')

    assert rs.response_errors['publisherUrl'].include?('invalid-url'), 'url is marked as invalid'
    assert !rs.response_errors['publisherUrl'].include?('mandatory'), 'not described as mandatory'
  end
end

class ResponseSetUpdateTimeTest < ActiveSupport::TestCase

  class QueryCounter < ActiveSupport::LogSubscriber

    cattr_accessor :count
    cattr_accessor :active

    def self.reset!
      self.count = 0
    end

    def self.in
      self.active = true
      reset!
      yield
      return count
    ensure
      self.active = false
    end

    def print?
      self.class.active && ENV.fetch('QUERY_COUNTER_LOG', 'false') == "true"
    end

    def print(msg)
      $stderr.puts(msg) if self.print?
    end

    def sql(event)
      payload = event.payload
      unless ['SCHEMA', nil].include?(payload[:name])
        self.class.count += 1
        print "#{payload[:name]} #{payload[:sql][0..100]}"
        print payload[:binds].map(&:last).inspect if payload[:binds].present?
        from = Rails.backtrace_cleaner.clean(caller)
        print "From: #{from[0]}"
      end
    end

  end

  QueryCounter.attach_to :active_record

  def in_less_queries_than(limit, label, &block)
    count = QueryCounter.in(&block)
    assert count <= limit, "#{label}: #{count} queries is too many"
  end

  test "updating a single response" do
    load_custom_survey 'cert_generator.rb'
    survey = Survey.newest_survey_for_access_code('cert-generator')
    response_set = ResponseSet.create!(:survey => survey)
    in_less_queries_than(30, "a single update") do
      response_set.update_responses('dataTitle' => 'a title response')
    end
  end

  test "updating two responses" do
    load_custom_survey 'cert_generator.rb'
    survey = Survey.newest_survey_for_access_code('cert-generator')
    response_set = ResponseSet.create!(:survey => survey)
    in_less_queries_than(40, "updating 2 responses") do
      response_set.update_responses(
        'dataTitle' => 'a title response',
        'releaseType' => 'oneoff'
      )
    end
  end

  test "updating a full response_set" do
    load_custom_survey 'cert_generator.rb'
    stub_request(:head, "example.com").to_return(status: 200)
    survey = Survey.newest_survey_for_access_code('cert-generator')
    response_set = ResponseSet.create!(:survey => survey)
    in_less_queries_than(80, "updating a response_set") do
      response_set.update_responses(
        'dataTitle' => 'a title response',
        'documentationUrl' => 'http://example.com',
        'publisherUrl' => 'http://example.com',
        'releaseType' => 'oneoff',
        'publisherRights' => 'yes',
        'publisherOrigin' => 'true',
        'chooseAny' => %w[one three],
        'cats' => 'mammal'
      )
    end
  end

end
