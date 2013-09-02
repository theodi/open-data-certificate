class RetrospectivelySetFullTitleOnSurveys < ActiveRecord::Migration
  def up

    Survey.where(full_title: nil).each do |survey|
      #find the newest survey with the same title
      full_title = Survey.where(title: survey.title).order('survey_version DESC').first.try(:full_title)

      # update the column, so it doesn't increment the survey version (and override the newest one)
      survey.update_column(:full_title, full_title) unless full_title.nil?
    end

  end

  def down

  end
end
