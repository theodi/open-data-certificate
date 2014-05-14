class SelectInput < Formtastic::Inputs::SelectInput

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
          hidden_input,
          label_html,
          options[:group_by] ? grouped_select_html : select_html,
          "<div class='status-icon'>",
            "<i class='icon icon-variable'></i>",
            "<i class='icon-loading icon-spin icon-refresh icon-large'></i>",
          "</div>",
          "<div class='clear-margin'></div>",
        "</div>",
        "<div class='status-below status-below-compact'>",
          "<div class='span8 status-message'>",
            "<span>#{status[:message]}</span><i class='arrow-border'></i><i class='arrow'></i>",
          "</div>",
        "</div>"
      ].join("\n").html_safe
    end
  end

end
