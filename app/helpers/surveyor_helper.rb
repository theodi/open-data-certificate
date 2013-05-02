module SurveyorHelper
  include Surveyor::Helpers::SurveyorHelperMethods

  def q_text(q, context=nil, locale=nil)
    "#{q.text_for(nil, context, locale)}"
  end
end
