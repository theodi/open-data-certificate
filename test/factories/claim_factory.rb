FactoryGirl.define do
  factory :claim do
    initiating_user factory: :user
    user
    dataset

    factory :claim_on_published_certificate do
      after(:create) do |claim|
        create(:response_set_with_dataset,
          user: claim.user,
          dataset: claim.dataset,
          aasm_state: :published,
          certificate: build(:published_certificate))
      end
    end
  end
end
