module ApplicationHelper
  def main_menu_navigation
    links = [
      { link_text: t('menu.create_certificate'), path: root_path },
      { link_text: t('menu.my_certificates'), path: root_path, requires_signed_in_user: true},
      { link_text: t('menu.browse_all_certificates'), path: certificates_path},
      { link_text: t('menu.search'), path: new_certificates_search_path},
      { link_text: t('menu.about'), path: '/about'},
      { link_text: t('menu.get_in_touch'), path: '/contact'},
    ]
    render partial: 'layouts/main_menu_navigation_link', collection: links, as: :link
  end

  def is_active_menu_link?(link)
    # fudged method to return 'true' the first time it's called, and then 'false' every time after that, to fake an 'active' menu item
    # TODO: write the code to calculate whether a menu item is active
    return_value = !@is_active_menu_link
    @is_active_menu_link = true
    return_value
  end
	def body_class
		content_for :body_class
	end
end
