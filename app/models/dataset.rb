class Dataset
  include Mongoid::Document
  field :title, type: String
  field :documentation_url, type: String
  field :curating_org, type: String
  field :curator_url, type: String
  field :data_kind, type: String
end
