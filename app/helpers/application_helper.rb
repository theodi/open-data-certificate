# encoding: utf-8

module ApplicationHelper

  def admin?
    current_user && current_user.admin?
  end

  def embed_protocol
    Rails.env.production? ? 'https://' : request.protocol
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

  def body_class
    content_for :body_class
  end

  def new_certificate(options={}, &block)
    text = t('menu.create_certificate')
    if user_signed_in?
      button = button_tag(options) { text }
      content = block ? capture(button, &block) : button
      form_tag(non_authenticated_start_questionnaire_path) do
        content
      end
    else
      link = link_to(text, non_authenticated_start_questionnaire_path(anchor: 'start-cert-modal'), options.merge('data-toggle' => :modal))
      block ? capture(link, &block) : link
    end
  end

	def body_class
		content_for :body_class
  end

  def jurisdiction_options_for_select(default=nil)
    surveys = Survey.available_to_complete.where('access_code not in (?)', Survey::MIGRATIONS.keys)
    options_for_select([[t('response_set.choose_jurisdiction'), nil]] + surveys.map{|s|[s.complete_title, s.access_code]}, default)
  end

  def locale_options_for_select(selected=nil)
    locales = I18n.available_locales.each_with_object({}) do |locale, memo|
      memo[t("locales.#{locale}", locale: locale)] = locale
    end
    options_for_select(locales, selected)
  end

  def certificate_locale_links(jurisdiction)
    locales = ::JURISDICTION_LANGS[jurisdiction]
    return unless locales.present?

    links = locales.map do |locale|
      locale_name = I18n.translate("locales.#{locale}", locale: locale)

      if locale == I18n.locale.to_s
        content_tag(:div, locale_name, class: 'badge badge-inverse')
      else
        link_to(locale_name, OdiLocale.changed_locale_path(request.fullpath, locale))
      end
    end

    safe_join(links)
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

  def example_certificate_link
    cert = Certificate.published.current.attained_level(:pilot).first
    return '' unless cert.present?

    link_to('Example dataset', dataset_latest_certificate_path(I18n.locale, cert.dataset), :class => ['btn', 'btn-large'])
  end

end
