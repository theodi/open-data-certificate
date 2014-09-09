class EmbedStat < ActiveRecord::Base
  belongs_to :dataset

  attr_accessible :referer

  validates :referer, url: true
end
