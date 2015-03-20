require 'delegate'

class CertificatePresenter < SimpleDelegator

  def published_data
    {
      name: name,
      publisher: curator,
      created: created_at,
      user: published_email,
      country: survey_title,
      type: survey_status,
      level: attained_level,
      verification_type: certification_type,
      date_verified: verifications.count == 0 ? nil : verifications.last.updated_at
    }
  end

  def all_data
    {
      name: name,
      publisher: curator,
      user_email: published_email,
      user_name: user_name,
      created: created_at,
      last_edited: updated_at,
      country: survey_title,
      status: expired? ? 'expired' : status,
      level: attained_level,
    }
  end

  def user_name
    user.try(:name).to_s
  end

  def published_email
    user.try(:email).presence || "N/A"
  end

  def survey_title
    survey.try(:title) || 'orphaned certificate'
  end

  def survey_status
    survey.try(:status) || "N/A"
  end

end
