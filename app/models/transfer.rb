class Transfer < ActiveRecord::Base
  include AASM

  attr_accessible :target_email

  belongs_to :user
  belongs_to :dataset

  validates :target_email, presence: true
  validates_associated :user, :dataset

  aasm do
    state :new, :initial => true

    state :notified, :before_enter => :notify_target_user

    event :notify do
      transitions from: :new, to: :notified
    end


    # state :accepted

    # state :cancelled


  end

  private

  def notify_target_user
    # send an email out
  end

end
