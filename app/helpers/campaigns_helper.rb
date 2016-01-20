module CampaignsHelper

  def missing_responses(generator, seperator = "\r\n")
    generator.response_set.missing_responses
             .split(",")
             .join(seperator)
  end

  def report_heading(level)
    case(level)
    when "uncertified"
      return "Missing metadata report"
    else
      return "Certification campaign results"
    end
  end

  def error_message_for(campaign, field)
    campaign.errors[field].join(', ') if campaign.errors[field]
  end

end
