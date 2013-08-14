class UpdateSurveyStatuses < ActiveRecord::Migration
  class Survey < ActiveRecord::Base
  end

  def up
    Survey.reset_column_information
    Survey.where(title: 'GB').update_all(status: 'beta')
  end
end
