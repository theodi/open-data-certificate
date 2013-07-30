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
      hidden_input <<
      label_html <<
      (options[:group_by] ? grouped_select_html : select_html) <<
      "<i class='icon-loading icon-spin icon-refresh icon-large'></i>".html_safe <<
      "<div class='status'><i class='icon icon-variable'></i><div class='span8 info'><span>#{status[:message]}</span></div></div>".html_safe
    end
  end

end
