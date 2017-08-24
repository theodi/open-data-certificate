module MainHelper

  def jurisdiction_count
    surveys = Survey.available_to_complete.where('access_code not in (?)', Survey::MIGRATIONS.keys)
    surveys.all.size  end

end
