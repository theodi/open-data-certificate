FactoryGirl.define do
  
  factory :dataset do
    title "Test dataset"
    documentation_url "http://www.example.com"

    factory :untitled_dataset do
      title nil
    end
    
    factory :dataset_without_documentation_url do
      documentation_url nil
    end
  end

end