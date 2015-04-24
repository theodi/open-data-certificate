module Ownership
  extend ActiveSupport::Concern

  def owned_by?(account)
    user.present? && user == account
  end

  def unowned?
    user.nil?
  end

  def unowned_or_by?(account)
    unowned? || owned_by?(account)
  end

end
