class Dataset < ActiveRecord::Base
  belongs_to :user

  has_many :response_sets, :order => "response_sets.created_at DESC"

  def title
    read_attribute(:title) || set_default_title!(response_sets.first.try(:title_determined_from_responses)) || response_sets.first.try(:title) || ResponseSet::DEFAULT_TITLE
  end

  def set_default_title!(title)
    if title && persisted?
      self.title = title
      save
    end
  end

  def newest_response_set
    response_sets.by_newest.limit(1).first
  end

  def newest_completed_response_set
    response_sets.completed.by_newest.limit(1).first
  end

end
