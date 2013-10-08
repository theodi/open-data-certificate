class Dataset < ActiveRecord::Base
  belongs_to :user

  attr_accessible :title

  after_touch :destroy_if_no_responses

  has_many :response_sets, :order => "response_sets.created_at DESC"
  has_many :certificates, :through => :response_sets

  # the currently published response set
  has_one :response_set, conditions: {aasm_state: 'published'}
  has_one :certificate, through: :response_set

  has_one :transfer, conditions: {aasm_state: :notified}

  def title
    read_attribute(:title) || set_default_title!(response_sets.first.try(:dataset_title_determined_from_responses)) || response_sets.first.try(:title) || ResponseSet::DEFAULT_TITLE
  end

  def documentation_url
    read_attribute(:documentation_url) || set_default_documentation_url!(response_sets.first.try(:dataset_documentation_url_determined_from_responses))
  end

  def curator
    read_attribute(:curator) || set_default_curator!(response_sets.first.try(:dataset_curator_determined_from_responses))
  end

  def set_default_title!(title)
    if title && persisted?
      self.title = title
      save unless readonly?
    end
  end

  def set_default_documentation_url!(url)
    if url && persisted?
      self.documentation_url = url
      save unless readonly?
      url
    end
  end

  def set_default_curator!(url)
    if url && persisted?
      self.documentation_url = url
      save unless readonly?
      url
    end
  end

  def newest_response_set
    response_sets.by_newest.limit(1).first
  end

  def newest_completed_response_set
    response_sets.completed.by_newest.limit(1).first
  end

  def destroy_if_no_responses
    destroy if response_sets.empty?
  end

  def user_full_name
    user.full_name if user
  end

end
