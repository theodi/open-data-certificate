require 'webmock/cucumber'
require 'coveralls'
Coveralls.wear_merged! 'rails'

def load_fixture(file)
  File.read( File.join( File.dirname(File.realpath(__FILE__)) , "fixtures", file ) )
end

Before do
  user = User.create(email: "admin@example.com", password: "12345678")
  ENV['ODC_ADMIN_IDS'] = user.id.to_s
  FactoryGirl.create(:survey, full_title:'UnitedKingdam', title:'GB', access_code: 'GB', survey_version: 1)
end
