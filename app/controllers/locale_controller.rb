class LocaleController < ApplicationController

  def change_locale
    redirect_to OdiLocale.changed_locale_path(params[:current_path], params[:new_locale])
  end

  def redirect_to_locale
    redirect_to request.fullpath.gsub(%r{\A/(.*)}, "/#{locale_for_redirect}/\\1")
  end

  private

  def locale_for_redirect
    if user_signed_in?
      current_user.preferred_locale
    else
      I18n.default_locale
    end
  end

end
