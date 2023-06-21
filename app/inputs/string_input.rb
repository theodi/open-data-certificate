class StringInput < Formtastic::Inputs::StringInput
  include SurveyorHelper

  # prevent the <label> from having the 'label' branch
  def label_html_options
    {
      :for => input_html_options[:id],
      :class => ['question_label'],
    }
  end

  def label_text
    ((localized_label || humanized_method_name) + requirement_text + ' ' + label_level_status).html_safe
  end

  def label_level_status
    question_requirement_with_badge(options[:minimum_level])
  end

  def to_html
    status = options[:status_message] || {}

    input_wrapping do
      [
        "<div class='status-wrapper'>",
          label_html,
          builder.text_field(method, input_html_options),
          "<div class='status-icon'>",
            "<i class='icon-loading icon-spin icon-refresh icon-large'></i>",
            "<i class='icon icon-variable'></i>",
          "</div>",
          "<a href='#' class='btn btn-danger remove_row #{'hide' unless options[:remove_button]}'><i class='icon icon-remove'></i>Remove</a>",
        "</div>",
        "<div class='status-below status-below-compact'>",
          "<div class='span8 status-message'><span>#{status[:message]}</span><i class='arrow-border'></i><i class='arrow'></i></div>",
        "</div>"
      ].join("\n").html_safe
    end
  end
end
