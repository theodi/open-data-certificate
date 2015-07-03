module CampaignsHelper

  def missing_responses(generator, seperator = "\r\n")
    generator.response_set.missing_responses
             .split(",")
             .join(seperator)
  end

  def certify(level)
    if (level=="No level certificates") || (level==nil)
      return "Uncertified: missing metadata report"
    else
      return nil
    end
  end

  def error_message_for(campaign, field)
    campaign.errors[field].join(', ') if campaign.errors[field]
  end

end
