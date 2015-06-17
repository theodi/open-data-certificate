require File.join(Rails.root, 'lib/extra/certificate_factory.rb')

task :certificate do
  ENV['JURISDICTION'] ||= "gb"
  if ENV['URL'] && ENV['USER_ID']
    cert = CertificateFactory::Certificate.new(ENV['URL'], ENV['USER_ID'], jurisdiction: ENV['JURISDICTION'])
    gen = cert.generate
  else
    puts "You must specifiy the Certificate URL and User ID"
  end
end

task :certificates do
  user_id = ENV['USER_ID']
  campaign = ENV['CAMPAIGN']
  limit = ENV['LIMIT']
  ENV['JURISDICTION'] ||= "gb"
  if ENV['URL']
    url = ENV['URL']
    CertificateFactory::FactoryRunner.perform_async(feed: url, user_id: user_id, limit: limit, campaign: campaign, jurisdiction: ENV['JURISDICTION'])
  else
    csv = ENV['CSV']
    CertificateFactory::CSVFactoryRunner.perform_async(file: csv, user_id: user_id, limit: limit, campaign: campaign, jurisdiction: ENV['JURISDICTION'])
  end
end
