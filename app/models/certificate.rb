class Certificate < ActiveRecord::Base
  belongs_to :response_set

  def self.search(search)
    query = self.where({})
    search.downcase.split(/\s+/).each do |term|
      query = query.where("LOWER(name) LIKE ?", "%#{term}%")
    end
    query
  end

  def self.by_newest
    order("created_at DESC")
  end

  def self.group_similar
    joins(:response_set => [:survey]).group('surveys.title, response_sets.dataset_id')
  end
end
