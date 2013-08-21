module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    if resource.errors.include?(:password)
      unless resource.errors.include?(:password_confirmation)
        resource.errors.add(:password_confirmation, '')
      end
    end


    html = <<-HTML
    <div class="alert alert-box alert-alert">
      <i class="icon-exclamation-sign icon-large icon-white"></i>
      <h3>#{I18n.t("errors.errors_occurred")}</h3>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def devise_error_messages?
    !resource.errors.empty?
  end
end
