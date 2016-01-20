class CertificateGeneratorWorker
  include Sidekiq::Worker

  def perform(certificate_generator_id, jurisdiction, create_user, dataset_id)
    generator = CertificateGenerator.find(certificate_generator_id)
    dataset = Dataset.find_by_id dataset_id
    unless generator.completed?
      generator.generate(jurisdiction, create_user, dataset)
    end
  end

end
