require 'webmock/cucumber'
require 'coveralls'
Coveralls.wear_merged! 'rails'

def load_fixture(file)
  File.read( File.join( File.dirname(File.realpath(__FILE__)) , "fixtures", file ) )
end

Before do
  FactoryGirl.create(:survey, full_title:'UnitedKingdam', title:'GB', access_code: 'GB', survey_version: 1)
end
