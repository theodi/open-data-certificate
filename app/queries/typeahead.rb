class TypeaheadQuery

  def initialize(query)
    @query = query
  end

  def country
    Survey.search({full_title_cont:@query}).result
          .joins(:response_sets).merge(ResponseSet.published)
          .group(:title)
          .order(:survey_version)
          .limit(5).map do |survey|
      {
        value: survey.full_title,
        path: Rails.application.routes.url_helpers.datasets_path(jurisdiction:survey.title)
      }
    end
  end

  def dataset
    Dataset.search({title_cont:@query}).result
           .includes(:response_set)
           .merge(ResponseSet.published)
           .limit(5).map do |dataset|
      {
        value: dataset.title,
        path: Rails.application.routes.url_helpers.dataset_path(dataset),
        attained_index: dataset.response_set.try(:attained_index)
      }
    end
  end

  def publisher
    Certificate.search({curator_cont:@query}).result
            .where(Certificate.arel_table[:curator].not_eq(nil))
            .includes(:response_set).merge(ResponseSet.published)
            .group(:curator)
            .limit(5).map do |dataset|
      {
        value: dataset.curator,
        path:  Rails.application.routes.url_helpers.datasets_path(publisher:dataset.curator)
      }
    end
  end

end
