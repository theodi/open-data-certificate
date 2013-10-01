class Transfer < ActiveRecord::Base
  include AASM

  attr_accessible :target_email, :dataset_id

  before_create :generate_token
  attr_readonly :token

  belongs_to :user
  belongs_to :target_user, class_name: 'User'
  belongs_to :dataset

  validates :target_email, presence: true
  validates_associated :user, :dataset
  validate :target_user_matches_target_email

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


    # state :cancelled

  end

  private

  def generate_token
    self.token = SecureRandom::hex(32)
  end

  def target_user_matches_target_email
    if target_user && target_user.email != target_email
      errors.base << "user does not match specified email address"
    end
  end

  def transfer_dataset
    dataset.update_attribute(:user_id, target_user_id)
    dataset.response_sets.update_all(user_id: target_user_id)
  end

  def has_target_user
    ! target_user.nil?
  end

  def notify_target_user
    TransferMailer.notify(self).deliver
  end

  #handle_asynchronously :notify_target_user

end
