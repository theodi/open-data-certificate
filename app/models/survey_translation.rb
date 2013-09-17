class SurveyTranslation < ActiveRecord::Base
  unloadable
  include Surveyor::Models::SurveyTranslationMethods

  # attempt to translate the locale using the translations themselves
  # fall back to the default defined on the survey
  def locale_name
    YAML.load(translation || "{}").with_indifferent_access[locale] || survey.default_locale_name
  end

end