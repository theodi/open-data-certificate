FactoryGirl.define do

  factory :transfer do
    user
    dataset

    sequence :target_email do |n|
      "target#{n}@example.com"
    end
  end

end