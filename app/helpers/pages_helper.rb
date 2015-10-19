module PagesHelper

  def faq_content(title, &block)
    content_for(:faq_navigation, content_tag(:li, link_to(title, anchor: title.parameterize)))
    content_for(:faq_body) do
      content_tag(:div, id: title.parameterize, class: 'faq') do
        concat content_tag(:h2, title)
        block.call
      end
    end
  end

  def faqs_with_navigation(html_options={}, &block)
    block.call

    capture do
      concat content_tag(:ul, content_for(:faq_navigation), html_options)
      concat content_for(:faq_body)
    end
  end

end
