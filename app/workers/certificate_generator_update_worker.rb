class CertificateGeneratorUpdateWorker
  include Sidekiq::Worker

  def perform(certificate_generator_id, jurisdiction, user_id)
    generator = CertificateGenerator.find(certificate_generator_id)
    create_user = User.find(user_id)
    CertificateGenerator.update(generator.dataset, nil, jurisdiction, create_user)
  end

end
