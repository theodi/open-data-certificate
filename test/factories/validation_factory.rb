FactoryGirl.define do

  factory :validation do |v|
    v.association :answer # v.answer_id         {}
    v.rule { "A" }
    v.message {}
  end

  factory :validation_condition do |v|
    v.association :validation # v.validation_id     {}
    v.rule_key { "A" }
    v.question_id {}
    v.operator { "==" }
    v.answer_id {}
    v.datetime_value {}
    v.integer_value {}
    v.float_value {}
    v.unit {}
    v.text_value {}
    v.string_value {}
    v.response_other {}
    v.regexp {}
  end
  
end