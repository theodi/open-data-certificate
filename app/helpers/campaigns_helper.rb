module CampaignsHelper

  def missing_responses(generator)
    response_set = generator.certificate.response_set
    response_set.incomplete_triggered_mandatory_questions
                .map { |q| q.text }
                .join("<br />")
  end

end
