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
   
  def data_kitten
    require 'data_kitten'
    dataset = DataKitten::Dataset.new(access_url: params[:url])
    unless dataset.supported? == nil
      render :json => {
        :title => dataset.data_title,
        :description => dataset.description,
        :publishers => dataset.publishers,
        :rights => dataset.rights,
        :licenses => dataset.licenses,
        :update_frequency => dataset.update_frequency,
        :keywords => dataset.keywords,
        :distributions => dataset.distributions
      }
    else
      render :nothing => true
    end
  end
end