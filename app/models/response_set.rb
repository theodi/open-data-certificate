class ResponseSet < ActiveRecord::Base
  include Surveyor::Models::ResponseSetMethods

  def incomplete!
    update_attribute :completed_at, nil
  end
end