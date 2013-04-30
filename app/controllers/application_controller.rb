class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale
 
  # pick the locale from ?locale=X in the url,  a prettier
  # solution might be used down the line, maybe depending
  # on the ui or user preferences maybe.
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # maintain the locale param on any urls
  def default_url_options(options={})
    { :locale => I18n.locale }
  end

end
