module CertificateFactory
  class Certificate

    def initialize(url, user_id, options = {})
      @url = url
      @user = User.find(user_id)
      @dataset_url = options[:dataset_url]
      @campaign_name = options[:campaign]
      @jurisdiction = options[:jurisdiction] || "cert-generator"
      @create_user = options[:create_user] || true
      @existing_dataset = options[:existing_dataset]
    end

    def generate
      generator = CertificateGenerator.create(
        request: {
          documentationUrl: @dataset_url
        },
        user: @user,
        certification_campaign: campaign
      )
      generator.delay.generate(@jurisdiction, @create_user, @existing_dataset)
    end

    def campaign
      if @campaign_name
        @campaign ||= CertificationCampaign.where(:user_id => @user.id).find_or_create_by_name(@campaign_name)
      end
    end

  end
end
