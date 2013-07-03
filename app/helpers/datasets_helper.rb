module DatasetsHelper

  def continue_path(response_set)
    unless response_set.new_record?
      surveyor.continue_my_survey_path(
        survey_code: response_set.survey.access_code, 
        response_set_code: response_set.access_code
      )
    end
  end

  def requirements_path(response_set)
    unless response_set.new_record?
      surveyor.view_my_survey_requirements_path(
        survey_code: response_set.survey.access_code, 
        response_set_code: response_set.access_code
      )
    end
  end

  def status_description_for_response_set_row(response_set)
    case
    when response_set.incomplete?
      t('dashboard.you_are_currently_editing_this_certificate')
    else
      if response_set.newest_completed_in_dataset?
        t('dashboard.latest_published_certificate')
      else
        t('dashboard.archived')
      end
    end
  end

  def status_class_for_response_set_row(response_set)
    case
    when response_set.incomplete?
      :editing
    else
      if response_set.newest_completed_in_dataset?
        :published
      else
        :archived
      end
    end
  end

end
