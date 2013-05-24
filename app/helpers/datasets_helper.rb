module DatasetsHelper
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

end
