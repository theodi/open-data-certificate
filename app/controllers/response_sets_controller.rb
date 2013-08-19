# Trying out having a separate controller from the central surveyor one.
class ResponseSetsController < ApplicationController

  load_and_authorize_resource

  def destroy
    @response_set.destroy
    redirect_to dashboard_path, notice: t('dashboard.deleted_response_set')
  end

  def publish
    begin
      @response_set.publish!
      redirect_to dashboard_path, notice: t('dashboard.published_response_set')
    rescue AASM::InvalidTransition
      redirect_to dashboard_path, alert: t('dashboard.unable_to_publish_response_set_invalid')
    end
  end

  def autofill
    @response_set.kitten_data = KittenData.new

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

      @response_set.kitten_data.data = {
        :title             => dataset.data_title,
        :description       => dataset.description,
        :publishers        => dataset.publishers,
        :rights            => dataset.rights,
        :licenses          => dataset.licenses,
        :update_frequency  => dataset.update_frequency,
        :keywords          => dataset.keywords,
        :release_date      => dataset.issued,
        :modified_date     => dataset.modified,
        :temporal_coverage => dataset.temporal,
        :distributions     => distributions
      }

      @response_set.kitten_data.save
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to dashboard_path, alert: t('dashboard.unable_to_access_response_set')
  end

end
