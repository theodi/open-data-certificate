class LocaleController < ApplicationController

  def change_locale
    redirect_to params[:current_path].gsub(%r{\A/[a-z]{2}/(.*)}, "/#{params[:new_locale]}/\\1")
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
