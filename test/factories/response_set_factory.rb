FactoryGirl.define do

  factory :response_set do |r|
    user
    r.association :survey # r.survey_id       {}
    r.access_code { Surveyor::Common.make_tiny_code }
    r.started_at { Time.now }

    factory :completed_response_set do
      completed_at { Time.now }
    end
  end

  factory :response_set_with_dataset, :class => ResponseSet do |r|
    user
    r.association :dataset
    r.association :survey # r.survey_id       {}
    r.access_code { Surveyor::Common.make_tiny_code }
    r.started_at { Time.now }
  end

  factory :response do |r|
    r.association :response_set # r.response_set_id   {}
    r.survey_section_id {}
    r.question_id {}
    r.answer_id {}
    r.datetime_value {}
    r.integer_value {}
    r.float_value {}
    r.unit {}
    r.text_value {}
    r.string_value {}
    r.response_other {}
    r.response_group {}
  end
  
end