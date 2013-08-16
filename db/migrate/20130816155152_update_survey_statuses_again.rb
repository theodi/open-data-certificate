# This is a repeat of the update_survey_statuses, because the status of new
# surveys wasn't being updated
class UpdateSurveyStatusesAgain < ActiveRecord::Migration
  class Survey < ActiveRecord::Base
  end

  def up
    Survey.reset_column_information
    Survey.where(title: 'GB').update_all(status: 'beta')
  end
end