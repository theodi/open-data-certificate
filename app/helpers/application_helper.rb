module ApplicationHelper

  def comment_link topic, message = 'comment', title = topic, key = nil
    content = "<i class=\"icon-comments\"></i> <span>#{message}</span>"
    link_to content.html_safe, comment_path(topic: topic, back: request.original_fullpath, title: title, key: key), class: 'link-comment'
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
    if value.kind_of?(Array)
      value.map {|v| kitten_value v}.join(' ')
    else
      case value.class.to_s
      when 'DataKitten::Agent'
        h(value.name) << ' ' << content_tag(:small, mail_to(value.mbox))
      when 'DataKitten::License'
        link_to(value.name, value.uri)
      when 'DataKitten::Temporal'
        h(value.start) + h(value.end)
      when 'String'
        h(value)
      when 'Date'
        h(value.to_s)
      when 'Hash'
        h(value[:title])
      else
        value
      end
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
      { link_text: t('menu.discussion'), path: discussion_path }
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

  def jurisdiction_options(available_surveys)
    # todo: cleanup, next two lines could be arel
    surveys = available_surveys.keep_if {|s| ! Survey::MIGRATIONS.has_key? s.access_code}
    surveys.sort! {|a,b| (a.full_title || a.title).to_s <=> (b.full_title || b.title).to_s }
    [[t('response_set.choose_jurisdiction'), nil]] + surveys.map{|s|[s.full_title || s.title, s.access_code]}
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

  private
  def new_certificate_link_hash(options={})
    if user_signed_in?
      { link_text: t('menu.create_certificate'), path: non_authenticated_start_questionnaire_path, post: true }
    else
      { :link_text => t('menu.create_certificate'), :path => non_authenticated_start_questionnaire_path(anchor: 'start-cert-modal'), 'data-toggle' => :modal }
    end.merge(options)
  end
end
