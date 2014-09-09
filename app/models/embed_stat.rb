class EmbedStat < ActiveRecord::Base
  has_one :certificate

  attr_accessible :referer

end
