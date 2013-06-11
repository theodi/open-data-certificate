class AddDisplayHeaderToSurveySection < ActiveRecord::Migration
  def change
    add_column :survey_sections, :display_header, :boolean, :default => true
  end
end
