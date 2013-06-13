class ValidatorsController < ApplicationController
  respond_to :js
  
  def resolve  
    if params[:url] =~ /^#{URI::regexp}$/
      code = HTTParty.get(params[:url]).code rescue nil
      Rails.cache.write(params[:url], code)
      render :json => {:status => code}
    else
      render :nothing => true
    end
  end
end
