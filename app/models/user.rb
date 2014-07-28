class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :datasets, :order => "created_at DESC"
  has_many :response_sets

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
    response_sets.any? do |r|
      unless r.certificate.nil? || ["draft", "archived"].include?(r.aasm_state)
        r.certificate.expired? || r.certificate.expiring?
      end
    end
  end

end
