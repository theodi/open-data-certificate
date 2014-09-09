class EmbedStat < ActiveRecord::Base
  has_one :certificate

  attr_accessible :referer

  validates :referer, url: true
end
