# Allow a question api_id to be mapped to a new one for 
# the response set if it's already been answered
# (to allow more agressive caching of the fields)
#
class ResponseCacheMap < ActiveRecord::Base
  attr_accessible :origin_id, :response_set_id, :target_id

  belongs_to :response_set
  belongs_to :origin, :class_name => 'Response'

  # not used anymore, just storing the api_id
  # belongs_to :target, :class_name => 'Response'


  def initialize(*args)
    super(*args)
    self.api_id ||= Surveyor::Common.generate_api_id
  end

end
