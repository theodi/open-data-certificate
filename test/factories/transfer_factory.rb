FactoryGirl.define do

  factory :transfer do
    user
    dataset

    sequence :target_email do |n|
      "target#{n}@example.com"
    end

    factory :notified_transfer do
      aasm_state 'notified'
    end
  end

end