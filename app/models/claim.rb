class Claim < ActiveRecord::Base
  include AASM

  belongs_to :dataset
  belongs_to :user
  belongs_to :initiating_user, class_name: 'User'

  validates_associated :user, :dataset, :initiating_user

  before_create do
    self.user ||= dataset.user
  end

  aasm do
    state :new, initial: true

    state :notified, before_enter: :notify_user

    state :accepted, before_enter: :transfer_dataset

    state :denied, before_enter: :notify_initiator

    event :notify do
      transitions from: :new, to: :notified
    end

    event :accept do
      transitions from: [:notified, :new], to: :accepted
    end

    event :deny do
      transitions from: [:notified, :new], to: :denied
    end
  end

  def transfer_dataset
    dataset.change_owner!(initiating_user)
  end

  def notify_user
    ClaimMailer.notify(id).deliver
  end
  handle_asynchronously :notify_user

  def notify_initiator
    ClaimMailer.notify_of_denial(id).deliver
  end
  handle_asynchronously :notify_initiator
end
