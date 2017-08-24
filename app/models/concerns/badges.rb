module Badges
  extend ActiveSupport::Concern

  def badge_file_for_level(level)
    if level == 'no_level'
      filename = 'no_level_badge.png'
    else
      filename = 'basic_level_badge.png'
    end

    File.open(File.join(Rails.root, 'app/assets/images/badges', filename))
  end

  def badge_file
    badge_file_for_level(attained_level)
  end

  def badge_url
    urlgen.badge_dataset_latest_certificate_path(dataset.id, format: 'png', locale: I18n.locale)
  end

  def embed_url
    urlgen.badge_dataset_latest_certificate_path(dataset.id, format: 'js', locale: I18n.locale)
  end

  private
  def urlgen
    Rails.application.routes.url_helpers
  end

end
