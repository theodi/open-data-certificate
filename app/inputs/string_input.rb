class StringInput < Formtastic::Inputs::StringInput

  # prevent the <label> from having the 'label' branch
  def label_html_options
    {
      :for => input_html_options[:id],
      :class => ['question_label'],
    }
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
        "<div class='status-below'>",
          "<div class='span8 status-message'><span>#{status[:message]}</span><i class='arrow-border'></i><i class='arrow'></i></div>",
        "</div>"
      ].join("\n").html_safe
    end
  end

end
