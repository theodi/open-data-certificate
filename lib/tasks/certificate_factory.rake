require File.join(Rails.root, 'lib/extra/certificate_factory.rb')
ENV['REDIS_URL'] = ENV['ODC_REDIS_SERVER_URL']

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
  url = ENV['URL']
  csv = ENV['CSV']
  user = User.find(ENV.fetch('USER_ID'))
  options = {
    user_id: user.id,
    limit: ENV['LIMIT'],
    jurisdiction: ENV.fetch('JURISDICTION', 'gb')
  }
  if campaign_name = ENV['CAMPAIGN']
    campaign = user.certification_campaigns.where(name: campaign_name).first_or_create(url: url)
    options[:campaign_id] = campaign.id
  end
  if url
    CertificateFactory::FactoryRunner.perform_async(options.merge(feed: url))
  else
    CertificateFactory::CSVFactoryRunner.perform_async(options.merge(file: csv))
  end
end
