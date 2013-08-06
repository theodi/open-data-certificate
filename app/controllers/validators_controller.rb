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
    dataset = DataKitten::Dataset.new(access_url: params[:url]) rescue nil
    if dataset != nil && dataset.supported?
      distributions = []
      
      dataset.distributions.try(:each) { |distribution|
        distributions << {
          :title       => distribution.title,
          :description => distribution.description,
          :access_url  => distribution.access_url,
          :extension   => distribution.format.extension,
          :open        => distribution.format.open?,
          :structured  => distribution.format.structured?
        }
      }
      
      render :json => {
        :data_exists       => true,
        :title             => dataset.data_title,
        :description       => dataset.description,
        :publishers        => dataset.publishers,
        :rights            => dataset.rights,
        :licenses          => dataset.licenses,
        :update_frequency  => dataset.update_frequency,
        :keywords          => dataset.keywords,
        :distributions     => distributions,
        :release_date      => dataset.issued,
        :modified_date     => dataset.modified,
        :temporal_coverage => dataset.temporal
      }
    else
      render :json => {
        :data_exists => false
      }
    end
  end
end