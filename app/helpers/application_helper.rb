# encoding: utf-8

module ApplicationHelper

  def admin?
    current_user && current_user.admin?
  end

  def comment_link topic, message = 'comment', title = topic, question_id = nil
    content = "<i class=\"icon-comments\"></i> <span>#{message}</span>"
    link_to content.html_safe, comment_path(topic: topic, back: request.original_fullpath, title: title, question_id: question_id), class: 'link-comment'
  end

  def embed_protocol
    Rails.env.production? ? 'https://' : request.protocol
  end

  # temporarily switch to a new locale
  def scope_locale locale
    locale, I18n.locale = I18n.locale, locale || I18n.locale
    yield
    I18n.locale = locale
  end

  # renders an item in the kittenData data
  def kitten_value value
    case value
    when Array
      safe_join(value.map {|v| kitten_value v}, ', ')
    when DataKitten::Agent
      if value.mbox
        safe_join([value.name, content_tag(:small, mail_to(value.mbox))], ' ')
      else
        value.name
      end
    when DataKitten::License
      link_to(value.name, value.uri.to_s)
    when DataKitten::Rights
      if value.uri
        link_to(I18n.t('data_kitten.rights_statement'), value.uri.to_s)
      end
    when DataKitten::Temporal
      dates = [kitten_value(value.start), kitten_value(value.end)].reject(&:blank?)
      safe_join(dates, ' — ') if dates.any?
    when String
      value
    when Date
      value.strftime('%-e %B %Y')
    when Hash
      value[:title]
    else
      value.to_s
    end
  end

  def kitten_field(kitten_data, key)
    value = kitten_value(kitten_data.get(key))
    if value.present?
      safe_join([
        content_tag(:dt, t(key, scope: :data_kitten)),
        content_tag(:dd, value)
      ], ' ')
    end
  end

  def markdown text
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    @markdown.render(text).html_safe
  end

  # the class for the main div (allows you to override .container when you
  # want more control)
  def main_container_class
    className = content_for(:main_container_class)
    className.blank? ? 'container main-default' : className
  end

  def main_menu_navigation
    links = [
      new_certificate_link_hash,
      { link_text: t('menu.my_certificates'), path: dashboard_path, requires_signed_in_user: true },
      { link_text: t('menu.browse_all_certificates'), path: datasets_path },
      { link_text: t('menu.discussion'), path: discussion_path },
      { link_text: t('menu.about'), path: about_path },
      { link_text: t('menu.admin'), path: admin_path, requires_signed_in_user: true, requires_admin_user: true}
    ]
    render partial: 'layouts/main_menu_navigation_list_item', collection: links, as: :link
  end

  def is_active_menu_link?(link)
    # fudged method to return 'true' the first time it's called, and then 'false' every time after that, to fake an 'active' menu item
    # TODO: write the code to calculate whether a menu item is active
    Rails.application.routes.recognize_path(link[:path]) == Rails.application.routes.recognize_path(request.env['REQUEST_PATH'])
  end

  def body_class
    content_for :body_class
  end

  def new_certificate_link(options={})
    render partial: 'layouts/main_menu_navigation_link', locals: { link: new_certificate_link_hash(options) }
  end

	def body_class
		content_for :body_class
  end

  def jurisdiction_options_for_select(default=nil)
    surveys = Survey.available_to_complete.where('access_code not in (?)', Survey::MIGRATIONS.keys)
    options_for_select([[t('response_set.choose_jurisdiction'), nil]] + surveys.map{|s|[s.complete_title, s.access_code]}, default)
  end

  # devise mapping
  def resource_name
    :user
  end

  # devise mapping
  def resource
    @resource ||= User.new
  end

  # devise mapping
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def icon_mark(name)
    content_tag(:i, '', class: "icon-#{name}")
  end

  def boolean_mark(value)
    value ? icon_mark("ok") : icon_mark("remove")
  end

  def atom_datetime(value)
    value.to_datetime.rfc3339.sub(/\+00:00$/, 'Z')
  end

  def modal_popup(id, cls, heading)
    close_button = content_tag(
      :button,
      '&times;'.html_safe,
      :class => 'close',
      :type => 'button',
      'data-dismiss' => 'modal',
      'aria-hidden' => true
    )
    modal_classes = "modal modal-wide hide fade #{cls}"
    cog = content_tag(:span, '', :class => 'icon-cog')
    content_tag(:div, :id => id, :class => modal_classes) do
      content_tag(:div, :class => 'modal-header') do
        title = content_tag(:h3, cog + " " + heading)
        close_button + title
      end +
      content_tag(:div, :class => 'modal-body') do
        yield
      end
    end
  end

  def example_dataset
    if cert = Certificate.published.current.attained_level(:pilot).first
      cert.dataset
    end
  end

  private
  def new_certificate_link_hash(options={})
    if user_signed_in?
      { link_text: t('menu.create_certificate'), path: non_authenticated_start_questionnaire_path, post: true }
    else
      { :link_text => t('menu.create_certificate'), :path => non_authenticated_start_questionnaire_path(anchor: 'start-cert-modal'), 'data-toggle' => :modal }
    end.merge(options)
  end
end
