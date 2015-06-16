require 'webmock/cucumber'
require 'coveralls'
require 'sidekiq/testing'

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
  builder = SurveyBuilder.new 'test/fixtures/surveys_custom', 'cert_generator.rb'
  builder.parse_file
  ENV['JURISDICTION'] = "cert-generator"
  #FactoryGirl.create(:survey, full_title:'UnitedKingdam', title:'GB', access_code: 'GB', survey_version: 1)
end
