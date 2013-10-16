class Transfer < ActiveRecord::Base
  include AASM

  attr_accessible :target_email, :dataset_id, :token_confirmation
  before_save :downcase_target_email

  before_create :generate_token
  attr_readonly :token
  attr_accessor :token_confirmation

  belongs_to :user
  belongs_to :target_user, class_name: 'User'
  belongs_to :dataset

  validates :target_email, presence: true
  validates_associated :user, :dataset

  aasm do
    state :new, initial: true

    state :notified, before_enter: :notify_target_user

    state :accepted, before_enter: :transfer_dataset, guard: :has_target_user

    event :notify do
      transitions from: :new, to: :notified
    end

    event :accept do
      transitions from: :notified, to: :accepted
    end
  end

  def token_match?
    token == token_confirmation
  end

  def target_email_match?
    target_user.try(:email) == target_email
  end

  def has_target_user?
    ! target_user.nil?
  end

  private

  def downcase_target_email
    self.target_email = self.target_email.downcase
  end

  def generate_token
    self.token = SecureRandom::hex(32)
  end

  def transfer_dataset
    dataset.update_attribute(:user_id, target_user_id)
    dataset.response_sets.update_all(user_id: target_user_id)
  end

  def notify_target_user
    TransferMailer.notify(self).deliver
  end

  #handle_asynchronously :notify_target_user

end
