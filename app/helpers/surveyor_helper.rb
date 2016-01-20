module SurveyorHelper
  include Surveyor::Helpers::SurveyorHelperMethods
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TranslationHelper
  include ActionView::Helpers::OutputSafetyHelper

  def q_text(q, context=nil, locale=nil)
    "#{q.text_for(nil, context, locale)}"
  end

  # Debug response_for method
  def response_for(response_set, responses, question, answer = nil, response_group = nil)
    return nil unless responses && question && question.id
    result = responses.detect{|r| (r.question_id == question.id) && (answer.blank? ? true : r.answer_id == answer.id) && (r.response_group.blank? ? true : r.response_group.to_i == response_group.to_i)}
    result ? result : response_set.responses.build(:question_id => question.id, :response_group => response_group)
  end

  def question_requirement_with_badge(level)
    popover_content = content_tag(:span, safe_join([
      content_tag(:i, '', class: ['badge', level]),
      content_tag(:strong, t("levels.#{level}.title") + ": "),
      t(level, scope: 'level_descriptions').html_safe,
    ]), class: 'odc-popover-content')

    cert = content_tag(:span, safe_join([
        t(level, scope: 'requirement_levels'),
        popover_content]),
      class: 'odc-popover')

    label = level == 'exemplar' ? :required_for_level : :required_for_level_and_above

    # rage at rails i18n, safety intertwingling
    return content_tag(:small, t(label, level: cert).html_safe)
  end

  def partial_for_question(q)
    q.is_requirement? ? '/partials/requirement' : '/partials/question'
  end

end
