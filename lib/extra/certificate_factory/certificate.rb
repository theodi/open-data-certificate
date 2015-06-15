module CertificateFactory
  class Certificate

    def initialize(url, user_id, options = {})
      @url = url
      @user = User.find(user_id)
      @dataset_url = options[:dataset_url]
      @campaign = options[:campaign]
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
        certification_campaign: @campaign
      )
      generator.delay.generate(@jurisdiction, @create_user, @existing_dataset)
    end

  end
end
