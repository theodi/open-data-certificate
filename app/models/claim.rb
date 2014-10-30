class Claim < ActiveRecord::Base
  include AASM

  DELIVERY_ADMIN_OVERRIDE = true

  belongs_to :dataset
  belongs_to :user
  belongs_to :initiating_user, class_name: 'User'

  validates_associated :user, :dataset, :initiating_user

  scope :outstanding, where(:aasm_state => [:new, :notified])

  before_create do
    self.user ||= dataset.user
  end

  aasm do
    state :new, initial: true

    state :notified, after_enter: :notify_user

    state :accepted, before_enter: :transfer_dataset!, after_enter: :notify_of_approval

    state :denied, after_enter: :notify_of_denial

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

  def transfer_dataset!
    dataset.change_owner!(initiating_user)
  end

  def notify_user
    ClaimMailer.notify(self).deliver
  end
  handle_asynchronously :notify_user

  def notify_of_denial
    ClaimMailer.notify_of_denial(self).deliver
  end
  handle_asynchronously :notify_of_denial

  def notify_of_approval
    ClaimMailer.notify_of_approval(self).deliver
  end
  handle_asynchronously :notify_of_approval
end
