FactoryGirl.define do

  factory :certificate do

    factory :published_certificate do
      aasm_state "published"
      published true
      published_at DateTime.now
    end
  end

  factory :certificate_with_dataset, :class => Certificate do
    name "Test certificate"
    after(:create) do |cert|
      FactoryGirl.create(:response_set_with_dataset, certificate: cert)
    end

    factory :published_certificate_with_dataset do
      aasm_state "published"
      published true
      published_at DateTime.now

      after(:create) do |cert|
        r = cert.response_set
        r.aasm_state = 'published'
        r.save
        cert.name = "Test dataset"
        cert.attained_level = "basic"
        cert.save
      end

      factory :published_basic_certificate_with_dataset do
      end

      factory :published_pilot_certificate_with_dataset do
        after(:create) do |cert|
          cert.name = "Test dataset"
          cert.attained_level = "pilot"
          cert.save
        end
      end

      factory :published_standard_certificate_with_dataset do
        after(:create) do |cert|
          cert.name = "Test dataset"
          cert.attained_level = "standard"
          cert.save
        end
      end

      factory :published_exemplar_certificate_with_dataset do
        after(:create) do |cert|
          cert.name = "Test dataset"
          cert.attained_level = "exemplar"
          cert.save
        end
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
