module CertificateFactory
  class Certificate

    def initialize(url, user_id, options = {})
      @url = url
      @user = User.find(user_id)
      @dataset_url = options[:dataset_url]
      @campaign_name = options[:campaign]
      @jurisdiction = options[:jurisdiction] || "gb"
      @create_user = options[:create_user] || true
      @existing_dataset = options[:existing_dataset]
      @feed_url = options[:feed_url]
    end

    def generate
      if existing_certificate?
        campaign.increment!(:duplicate_count) if campaign
      else
        generator = CertificateGenerator.create(
          request: {
            documentationUrl: @url
          },
          user: @user,
          certification_campaign: campaign
        )
        generator.sidekiq_delay.generate(@jurisdiction, @create_user, @existing_dataset)
      end
    end

    def existing_certificate?
      @existing_dataset = Dataset.where(documentation_url: @url).first
      @existing_dataset.try(:certificate).present?
    end

    def campaign
      if @campaign_name
        @campaign ||= CertificationCampaign.where(:user_id => @user.id).find_or_create_by_name_and_url(@campaign_name, @feed_url)
      end
    end

  end
end
