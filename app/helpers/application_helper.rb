module ApplicationHelper

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

  def after_sign_in_path_for(resource)
    # If the user has a survey stored in their session, assign it to them and redirect to the survey,
    # deleting the session id even if the response set isn't found
    case
      when session[:response_set_id] && response_set = ResponseSet.find(session.delete(:response_set_id))

        # Assign the response set to the user, creating a dataset for it
        response_set.assign_to_user!(current_user)

        return surveyor.edit_my_survey_path(
          :survey_code => response_set.survey.access_code,
          :response_set_code => response_set.access_code
        )


      when params[:form_id] == 'start_cert_modal_form'
        # if the user has authenticated from the start_cert_modal_form then redirect to the start_questionnaire path
        authenticated_start_questionnaire_path

      else
        dashboard_path
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
