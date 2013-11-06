class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :datasets, :order => "created_at DESC"
  has_many :response_sets

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :default_jurisdiction

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
end
