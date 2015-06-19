require 'webmock/cucumber'
require 'coveralls'
require 'sidekiq/testing'
require 'vcr'

Coveralls.wear_merged! 'rails'
Sidekiq::Testing.inline!

def load_fixture(file)
  File.read( File.join( File.dirname(File.realpath(__FILE__)) , "fixtures", file ) )
end

def execute_rake(file, task)
  require 'rake'
  rake = Rake::Application.new
  Rake.application = rake
  Rake::Task.define_task(:environment)
  load "#{Rails.root}/lib/tasks/#{file}.rake"
  rake[task].invoke
end

Before("@api") do
  @api_user = User.create(email: "api@example.com", password: "password", authentication_token: "")
  @api_user.admin = true
  @api_user.save
  builder = SurveyBuilder.new 'test/fixtures/surveys_custom', 'cert_generator.rb'
  builder.parse_file
  ENV['JURISDICTION'] = "cert-generator"
  #FactoryGirl.create(:survey, full_title:'UnitedKingdam', title:'GB', access_code: 'GB', survey_version: 1)
end

Before("@data_kitten") do
  class DataKitten::Dataset
    # this prevents DataKitten from making a request to the access_url
    def supported?
      true
    end
  end
end

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'fixtures/cassettes'
  c.default_cassette_options = { :record => :once }
end

VCR.cucumber_tags do |t|
  t.tag  '@vcr', :use_scenario_name => true
end
