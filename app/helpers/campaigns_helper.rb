module CampaignsHelper

  def missing_responses(generator, seperator = "\r\n")
    generator.response_set.missing_responses
             .split(",")
             .join(seperator)
  end

end
