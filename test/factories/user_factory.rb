FactoryGirl.define do

  factory :user do
    sequence :email do |n|
      "test#{n}@example.com"
    end

    password "testpassword"
    password_confirmation "testpassword"

    factory :user_with_responses do
      after(:create) do |user|
        FactoryGirl.create_list(:dataset, 3, user: user)
        user.datasets.each do |dataset|
          FactoryGirl.create_list(:response_set, 2, user: user, dataset: dataset)
        end
      end
    end
  end

end