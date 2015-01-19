class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :datasets, :order => "datasets.created_at DESC"
  has_many :response_sets
  has_many :sent_claims, class_name: 'Claim', foreign_key: 'initiating_user_id'
  has_many :received_claims, class_name: 'Claim', foreign_key: 'user_id'

  attr_accessible :name, :short_name, :email, :password, :password_confirmation, :default_jurisdiction, :organization, :agreed_to_terms

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

  def after_password_reset
    confirm!
  end

  # Coped from https://github.com/plataformatec/devise/blob/v3.0.3/lib/devise/models/database_authenticatable.rb
  # Sorry but I couldn't add a check around this method as .valid? wipes
  # other errors from the hash
  def update_with_password(params, *options)
    current_password = params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    # special case for rails handling of boolean check_box
    agreed_to_terms = params[:agreed_to_terms] == "1"

    result = if valid_password?(current_password) && agreed_to_terms
      update_attributes(params, *options)
    else
      self.assign_attributes(params, *options)
      self.valid?
      self.errors.add(:current_password, current_password.blank? ? :blank : :invalid) unless valid_password?(current_password)
      self.errors.add(:agreed_to_terms, :blank) unless agreed_to_terms?
      false
    end

    clean_up_passwords
    result
  end

  def to_s
    if name.present?
      "#{name} <#{email}>"
    else
      email
    end
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
