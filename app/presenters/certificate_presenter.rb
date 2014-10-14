require 'delegate'

class CertificatePresenter < SimpleDelegator

  def published_data
    {
      name: certificate.name,
      publisher: certificate.curator,
      created: certificate.created_at,
      user: certificate.user.nil? ? "N/A" : certificate.user.email,
      country: certificate.survey.title,
      type: certificate.survey.status,
      level: certificate.attained_level,
      verification_type: certificate.certification_type,
      date_verified: certificate.verifications.count == 0 ? nil : certificate.verifications.last.updated_at
    }
  end

  def all_data
    begin
      {
        name: certificate.name,
        publisher: certificate.curator,
        user_email: certificate.user.nil? ? "N/A" : certificate.user.email,
        user_name: "#{certificate.user.first_name} #{certificate.user.last_name}",
        created: certificate.created_at,
        last_edited: certificate.updated_at,
        country: certificate.survey.title,
        status: certificate.expired? ? 'expired' : certificate.status,
        level: certificate.attained_level,
      }
    rescue
      nil
    end
  end

  def certificate
    __getobj__
  end

end
