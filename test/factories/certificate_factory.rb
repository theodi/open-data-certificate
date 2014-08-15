FactoryGirl.define do

  factory :certificate do
    after(:create) do |cert|
      cert.update_attribute(:response_set, FactoryGirl.create(:response_set, certificate: cert)) if cert.response_set.nil?
    end

    factory :published_certificate do
      aasm_state "published"
      published true
      published_at DateTime.now
    end
  end

  factory :certificate_with_dataset, :class => Certificate do
    name "Test certificate"
    after(:create) do |cert|
      Certificate.any_instance.stubs(:update_from_response_set).returns(nil)
      cert.update_attribute(:response_set, FactoryGirl.create(:response_set_with_dataset, certificate: cert)) if cert.response_set.nil?
    end

    factory :published_certificate_with_dataset do
      aasm_state "published"
      published true
      published_at DateTime.now
      attained_level "basic"

      after(:create) do |cert|
        Certificate.any_instance.stubs(:update_from_response_set).returns(nil)
        cert.update_attribute(:response_set, FactoryGirl.create(:response_set_with_dataset, certificate: cert, aasm_state: 'published')) if cert.response_set.nil?
      end

      factory :published_pilot_certificate_with_dataset do
        attained_level "pilot"
      end

      factory :published_standard_certificate_with_dataset do
        attained_level "standard"
      end

      factory :published_exemplar_certificate_with_dataset do
        attained_level "exemplar"
      end

      factory :published_certificate_with_removed_dataset do
        after(:create) do |certificate, evaluator|
          certificate.dataset.update_attribute('removed', true)
        end
      end

      factory :published_audited_certificate_with_dataset do
        after(:create) do |certificate, evaluator|
          certificate.update_attribute('audited', true)
        end
      end
    end
  end

end
