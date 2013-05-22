class Certificate < ActiveRecord::Base
  belongs_to :response_set

  class << self
    def search(search)
      query = self.where({})
      search.downcase.split(/\s+/).each do |term|
        query = query.where("LOWER(certificates.name) LIKE ?", "%#{term}%")
      end
      query
    end

    def by_newest
      order("certificates.created_at DESC")
    end

    def group_similar
      joins(:response_set => [:survey]).group('surveys.title, response_sets.dataset_id')
    end
  end

end
