require File.join(Rails.root, 'lib/extra/certificate_factory.rb')

task :certificate do
  if ENV['URL'] && ENV['USER_ID']
    cert = CertificateFactory::Certificate.new(ENV['URL'], ENV['USER_ID'])
    gen = cert.generate
  else
    puts "You must specifiy the Certificate URL and User ID"
  end
end
