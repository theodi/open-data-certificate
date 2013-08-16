FactoryGirl.define do

  factory :dependency do |d|
    # the dependent question
    d.association :question # d.question_id       {}
    d.question_group_id {}
    d.rule { "A" }
  end

  factory :dependency_condition do |d|
    d.association :dependency # d.dependency_id    {}
    d.rule_key { "A" }
                              # the conditional question
    d.question_id {}
    d.operator { "==" }
    d.answer_id {}
    d.datetime_value {}
    d.integer_value {}
    d.float_value {}
    d.unit {}
    d.text_value {}
    d.string_value {}
    d.response_other {}
  end
  
end