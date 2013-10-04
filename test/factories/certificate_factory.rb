FactoryGirl.define do
  
  factory :certificate do
    response_set

    factory :published_certificate do
      published true
    end
  end

  factory :certificate_with_dataset, :class => Certificate do
    name "Test certificate"
    response_set { FactoryGirl.create(:response_set_with_dataset) }

    factory :published_certificate_with_dataset do
      published true
      attained_level "basic"
      response_set {FactoryGirl.create(:response_set_with_dataset, aasm_state: 'published')}
      
      factory :published_pilot_certificate_with_dataset do
        attained_level "pilot"
      end

      factory :published_standard_certificate_with_dataset do
        attained_level "standard"
      end
      
      factory :published_expert_certificate_with_dataset do
        attained_level "expert"
      end

      factory :published_certificate_with_removed_dataset do
        after(:create) do |certificate, evaluator|
          certificate.dataset.update_attribute('removed', true)
        end
      end
    end
  end

end