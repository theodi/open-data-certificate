# Be sure to restart your server when you modify this file.

I18n.load_path += Dir[Rails.root.join('surveys/translations/questionnaire.*.yml')]

# set up language fallbacks so we don't see a lot of blank
# space in development.
I18n.backend.class.send(:include, I18n::Backend::Fallbacks)

I18n.fallbacks.map('fr' => 'en')

JURISDICTION_LANGS = YAML.load_file('surveys/translations/jurisdiction_languages.yml')
OpenDataCertificate::Application.config.i18n.available_locales = JURISDICTION_LANGS.map(&:last).flatten.uniq.sort

unless Rails.env.production?
  OpenDataCertificate::Application.config.i18n.available_locales += ['bl', 'db']
end
