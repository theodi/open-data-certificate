class Dataset < ActiveRecord::Base
  belongs_to :user

  has_many :response_sets, :order => "response_sets.created_at DESC"

  def set_default_title!(title)
    if title.nil?
        title = title
        save
    end
  end
end
