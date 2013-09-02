class AdditionalTextInput < Formtastic::Inputs::TextInput

  # prevent the <label> from having the 'label' branch
  def input_html_options
    {
      :cols => builder.default_text_area_width,
      :rows => builder.default_text_area_height
    }.merge(super)
  end

  def to_html
    input_wrapping do
      [
        label_html,
        "<p>#{options[:subtitle]}</p>",
        builder.text_area(method, input_html_options)
      ].join('').html_safe
    end
  end

end
