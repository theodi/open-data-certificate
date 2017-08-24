require 'webmock/cucumber'
require 'sidekiq/testing'
require 'vcr'
begin
  require 'pry'
rescue LoadError
end

if ENV['COVERAGE']
  require 'coveralls'
  Coveralls.wear_merged! 'rails'
end

ENV['CERTIFICATE_HOSTNAME'] = 'test.host'
Sidekiq::Testing.inline!

def load_fixture(file)
  File.read( File.join( File.dirname(File.realpath(__FILE__)) , "fixtures", file ) )
end

Before("@api") do
  @api_user = User.create(email: "api@example.com", password: "password", authentication_token: "")
  @api_user.admin = true
  @api_user.save
  builder = SurveyBuilder.new 'test/fixtures/surveys_custom', 'cert_generator.rb'
  builder.parse_file
  ENV['JURISDICTION'] = "cert-generator"
end

Before("@survey") do
  builder = SurveyBuilder.new 'surveys/development', 'odc_questionnaire.UK.rb'
  builder.parse_file
end

Before("@stub_survey") do
  Survey.create(full_title: "United Kingdom", title: "GB", access_code: "gb")
end

Before("@sidekiq_fake") do
  Sidekiq::Testing.fake!
end

After("@sidekiq_fake") do
  Sidekiq::Testing.inline!
end

Before("@ignore") do |scenario|
  skip_this_scenario
end

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'fixtures/cassettes'
  c.default_cassette_options = { :record => :once }
end

VCR.cucumber_tags do |t|
  t.tag  '@vcr', :use_scenario_name => true
end
