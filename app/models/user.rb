class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :datasets, :order => "datasets.created_at DESC"
  has_many :response_sets
  has_many :sent_claims, class_name: 'Claim', foreign_key: 'initiating_user_id'
  has_many :received_claims, class_name: 'Claim', foreign_key: 'user_id'
  has_many :certification_campaigns

  attr_accessible :name, :short_name, :email, :password, :password_confirmation, :default_jurisdiction, :organization, :agreed_to_terms, :preferred_locale, :inhuman

  before_save :ensure_authentication_token

  validates :agreed_to_terms, acceptance: {accept: true}, allow_nil: true
  validates :preferred_locale, inclusion: {in: I18n.available_locales.map(&:to_s)}

  # Spam filtering only
  attr_accessor :inhuman
  validates :inhuman, inclusion: { :in => ["0"] }, allow_nil: true

  def self.engaged_users
    User.where("confirmed_at IS NOT NULL").select { |u| !u.datasets.blank? }
  end

  def has_engaged?
    confirmed? && !datasets.blank?
  end

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

  def after_password_reset
    confirm!
  end

  def to_s
    if name.present?
      "#{name} <#{email}>"
    else
      email
    end
  end

  def default_jurisdiction
    super || 'gb'
  end

  # name isn't mandatory on signup, so fall back to email
  def identifier
    name.presence || email.split('@').join(' from ')
  end

  def greeting
    short_name.presence || name.presence || email.split("@").first
  end

  def has_expired_or_expiring_certificates?
    response_sets.published.includes(:certificate).merge(Certificate.past_expiry_notice).any?
  end

end
