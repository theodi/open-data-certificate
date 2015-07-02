namespace :cache do
  desc "Caches uncached missing_responses"
  task :missing_responses  => :environment do
    # We're only caching those response sets that have campaigns because caching them all would take an age
    CertificationCampaign.all.each do |campaign|
      campaign.certificate_generators.includes(:dataset, :certificate).each do |generator|
        generator.response_set.save rescue nil
      end
    end
  end
end
