class CertificateGeneratorWorker
  include Sidekiq::Worker

  def perform(certificate_generator_id, jurisdiction, dataset_id)
    generator = CertificateGenerator.find(certificate_generator_id)
    dataset = Dataset.find_by_id dataset_id
    generator.generate(jurisdiction, true, dataset)
  end

end
