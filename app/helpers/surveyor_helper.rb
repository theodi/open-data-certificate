module SurveyorHelper
  include Surveyor::Helpers::SurveyorHelperMethods

  def q_text(q, context=nil, locale=nil)
    "#{q.text_for(nil, context, locale)}"
  end

  # gives the requirement text without the  "you must"
  # or "you should" prefix.
  #
  # not locale friendly
  # 
  def without_instruction(text)
    text.gsub(/^you (should|must)/i, '').gsub(/\.$/, '')
  end
end
