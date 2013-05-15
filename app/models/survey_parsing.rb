class SurveyParsing < ActiveRecord::Base
  # Placeholder to track the MD5 of a survey file, so the deployment rake task can determine whether the survey has been
  # updated or not.
  attr_accessible :file_name
end
