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
      "<div class='status-wrapper'>".html_safe <<
        label_html <<
        builder.text_field(method, input_html_options) <<
        "<i class='icon-loading icon-spin icon-refresh icon-large'></i>".html_safe <<
        "<div class='status-icon'><i class='icon icon-variable'></i></div>".html_safe <<
      "</div>".html_safe <<
      "<div class='span8 status-message'><span>#{status[:message]}</span><i class='arrow-border'></i><i class='arrow'></i></div>".html_safe
    end
  end

end
