class Verification < ActiveRecord::Base
  belongs_to :user
  belongs_to :certificate

  attr_accessible :value, :user_id

  validates :user_id,        presence: true, uniqueness: {scope: :certificate_id}
  validates :certificate_id, presence: true
  validate  :not_same_user

  def not_same_user
    if self.user == certificate.try(:user)
      errors.add(:user_id, "cannot self validate")
    end
  end
end
