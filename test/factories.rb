FactoryGirl.define do

  factory :user do
    email "test@example.com"
    password "testpassword"
    password_confirmation "testpassword"
  end

  factory :dataset do
    title "test-dataset"
  end
  
end
