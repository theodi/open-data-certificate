FactoryGirl.define do
  
  factory :certificate do
    response_set

    factory :published_certificate do
      published true
    end
  end

  factory :certificate_with_dataset, :class => Certificate do
    response_set { FactoryGirl.create(:response_set_with_dataset) }

    factory :published_certificate_with_dataset do
      published true
    end
  end

end