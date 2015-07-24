class SurveyTranslation < ActiveRecord::Base
  unloadable
  include Surveyor::Models::SurveyTranslationMethods

  def locale_name
    I18n.translate(locale, scope: 'locales') || to_hash[locale] || locale
  end

  def to_hash
    @to_hash ||= YAML.load(translation || "{}")
  end

end
