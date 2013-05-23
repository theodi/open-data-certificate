require 'test_helper'

class ResponseSetTest < ActiveSupport::TestCase

  should belong_to(:dataset)
  should have_one(:certificate)

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
    question = FactoryGirl.create(:question, is_mandatory: false)

    survey_section = question.survey_section
    survey = survey_section.survey

    # mandatory question, but not triggered
    mandatory_question = FactoryGirl.create(:question, is_mandatory: true, survey_section: survey_section)
    dependency = FactoryGirl.create(:dependency, question: mandatory_question)
    FactoryGirl.create :dependency_condition, dependency: dependency, operator: 'count>2'

    # triggered mandatory question
    triggered_mandatory_question = FactoryGirl.create(:question, is_mandatory: true, survey_section: survey_section)
    survey.reload

    response_set = FactoryGirl.create(:response_set, survey: survey)

    assert_equal response_set.triggered_mandatory_questions, [triggered_mandatory_question]
  end

  test "#triggered_requirements should return an array of all the requirements that are triggered by their dependencies for the response_set" do
    survey_section = FactoryGirl.create(:survey_section)
    survey = survey_section.survey

    # non-triggered requirement
    question = FactoryGirl.create(:question, requirement: 'level_1', survey_section: survey_section)
    requirement = FactoryGirl.create(:requirement, requirement: 'level_1', survey_section: survey_section)
    dependency = FactoryGirl.create(:dependency, question: requirement)
    FactoryGirl.create :dependency_condition, question: question, dependency: dependency, operator: 'count>2'

    # non-triggered requirement
    question = FactoryGirl.create(:question, requirement: 'level_2', survey_section: survey_section)
    requirement = FactoryGirl.create(:requirement, requirement: 'level_2', survey_section: survey_section)
    dependency = FactoryGirl.create(:dependency, question: requirement)
    FactoryGirl.create :dependency_condition, question: question, dependency: dependency, operator: 'count>2'

    # triggered requirement
    question = FactoryGirl.create(:question, requirement: 'level_3', survey_section: survey_section)
    requirement = FactoryGirl.create(:requirement, requirement: 'level_3', survey_section: survey_section)
    dependency = FactoryGirl.create(:dependency, question: requirement)
    FactoryGirl.create :dependency_condition, question: question, dependency: dependency, operator: 'count<2'
    survey.reload

    response_set = FactoryGirl.create(:response_set, survey: survey)

    assert_equal response_set.triggered_requirements, [requirement]
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

  test "#completed_requirements returns only triggered_requirements that are met by responses" do
    triggered_requirements = [stub(requirement: 'level_1', requirement_met_by_responses?: true),
                              stub(requirement: 'level_2', requirement_met_by_responses?: false),
                              stub(requirement: 'level_3', requirement_met_by_responses?: false),
                              stub(requirement: 'level_4', requirement_met_by_responses?: false),
    ]

    response_set = FactoryGirl.create(:response_set)
    response_set.stubs(:triggered_requirements).returns(triggered_requirements)

    assert_equal [triggered_requirements.first], response_set.completed_requirements
  end

  test "#outstanding_requirements returns only triggered_requirements that are not met by responses" do
    triggered_requirements = [stub(requirement: 'level_1', requirement_met_by_responses?: true),
                              stub(requirement: 'level_2', requirement_met_by_responses?: true),
                              stub(requirement: 'level_3', requirement_met_by_responses?: true),
                              stub(requirement: 'level_4', requirement_met_by_responses?: false),
    ]

    response_set = FactoryGirl.create(:response_set)
    response_set.stubs(:triggered_requirements).returns(triggered_requirements)

    assert_equal [triggered_requirements.last], response_set.outstanding_requirements
  end

  test "#title_determined_from_responses returns the answer of the response to the question referenced as 'dataTitle'" do
    question = FactoryGirl.create(:question, reference_identifier: 'dataTitle')
    answer = FactoryGirl.create(:answer, question: question)
    expected_value = 'my response set title'
    response_set = FactoryGirl.create(:response_set, survey: question.survey_section.survey)
    response = FactoryGirl.create(:response, response_set: response_set, string_value: expected_value, question: question, answer: answer)

    assert_equal expected_value, response_set.title_determined_from_responses
  end

  test "#title returns the title determined from the responses if there is one" do
    question = FactoryGirl.create(:question, reference_identifier: 'dataTitle')
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

  test "#incomplete? returns true for an incomplete response_set" do
    assert_equal true, FactoryGirl.build(:response_set).incomplete?
  end

  test "#incomplete? returns false for an complete response_set" do
    assert_equal false, FactoryGirl.build(:completed_response_set).incomplete?
  end

  test "#generate_certificate creates a new certificate on save of completed response_sets" do
    attained_level = 'test_level'
    response_set = FactoryGirl.build(:completed_response_set)
    response_set.stubs(:attained_level).returns(attained_level)
    assert_nil response_set.certificate
    response_set.save!
    assert_equal attained_level, response_set.certificate.try(:attained_level)
  end

  test "#generate_certificate does not overwrite existing certificate" do
    response_set = FactoryGirl.create(:completed_response_set)
    assert_not_nil certificate = response_set.certificate
    response_set.generate_certificate
    assert_equal certificate, response_set.certificate
  end

  test "Should be able to assign_to_user - which creates dataset" do
    response_set = FactoryGirl.create(:response_set)
    user = FactoryGirl.create(:user)
    assert [response_set.user, response_set.dataset].none?
    response_set.assign_to_user!(user)

    assert_equal user, response_set.user
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

end