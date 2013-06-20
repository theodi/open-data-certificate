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
   
  def autofill
    dataset = DataKitten::Dataset.new(access_url: params[:url])
    if dataset.supported?
      render :json => {
        :title => dataset.data_title,
        :description => dataset.description,
        :publishers => dataset.publishers,
        :rights => dataset.rights,
        :licenses => dataset.licenses,
        :update_frequency => dataset.update_frequency,
        :keywords => dataset.keywords,
        :distributions => dataset.distributions,
        :release_date => dataset.issued,
        :modified_date => dataset.modified,
        :temporal_coverage => dataset.temporal
      }
    else
      render :nothing => true
    end
  end
end