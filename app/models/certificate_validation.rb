class CertificateValidation < ActiveRecord::Base
  belongs_to :user
  belongs_to :certificate

  attr_accessible :value

  validates :user, presence: true
  validates :certificate, presence: true
  validate :not_same_user

  def not_same_user
    errors.add(:user_id, "cannot self validate") if self.user == certificate.try(:user)
  end
end
