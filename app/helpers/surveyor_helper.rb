module SurveyorHelper
  include Surveyor::Helpers::SurveyorHelperMethods

  def q_text(q, context=nil, locale=nil)
    "#{q.text_for(nil, context, locale)}"
  end

  # Debug response_for method
  def response_for(response_set, responses, question, answer = nil, response_group = nil)
    return nil unless responses && question && question.id
    result = responses.detect{|r| (r.question_id == question.id) && (answer.blank? ? true : r.answer_id == answer.id) && (r.response_group.blank? ? true : r.response_group.to_i == response_group.to_i)}
    result ? result : response_set.responses.build(:question_id => question.id, :response_group => response_group)
  end
end
