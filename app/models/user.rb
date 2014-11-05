class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :datasets, :order => "datasets.created_at DESC"
  has_many :response_sets
  has_many :sent_claims, class_name: 'Claim', foreign_key: 'initiating_user_id'
  has_many :received_claims, class_name: 'Claim', foreign_key: 'user_id'

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :default_jurisdiction

  before_save :ensure_authentication_token

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  def full_name
    [first_name, last_name].delete_if(&:blank?).join(' ')
  end

  def to_s
    if full_name.present?
      "#{full_name} (#{email})"
    else
      email
    end
  end

  # name isn't mandatory on signup, so fall back to email
  def identifier
    unless full_name.blank?
      full_name
    else
      email.split('@').join(' from ')
    end
  end

  def admin?
    (ENV['ODC_ADMIN_IDS'] || '').split(',').include? id.to_s
  end

  def has_expired_or_expiring_certificates?
    response_sets.published.includes(:certificate).merge(Certificate.past_expiry_notice).any?
  end

end
