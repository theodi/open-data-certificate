class LocaleController < ApplicationController

  def change_locale
    redirect_to OdiLocale.changed_locale_path(params[:current_path], params[:new_locale])
  end

  def redirect_to_locale
    new_path = request.fullpath.gsub(%r{\A/(.*)}, "/#{locale_for_redirect}/\\1")

    if recognized_path?(new_path)
      redirect_to new_path
    else
      raise ActionController::RoutingError, 'Not Found'
    end
  end

  private

  def locale_for_redirect
    if user_signed_in?
      current_user.preferred_locale
    else
      I18n.default_locale
    end
  end

  def recognized_path?(path)
    path_params = Rails.application.routes.recognize_path(path)
    path_params && !(path_params[:controller] == 'locale' && path_params[:action] == 'redirect_to_locale')
  end

end
