# Be sure to restart your server when you modify this file.


# set up language fallbacks so we don't see a lot of blank
# space in development.
I18n.backend.class.send(:include, I18n::Backend::Fallbacks)

I18n.fallbacks.map('fr' => 'en')
