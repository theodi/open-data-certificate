module ApplicationHelper

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
      #{ link_text: t('menu.browse_all_certificates'), path: certificates_path }, #TODO: Commented browse certificate functionality
      { link_text: t('footmenu.about'), path: '/about' }, #TODO: Commented browse certificate functionality - added this item temporarily so the menu isn't spartan
      { link_text: t('footmenu.get_in_touch'), path: '/contact' }, #TODO: Commented browse certificate functionality - added this item temporarily so the menu isn't spartan
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
