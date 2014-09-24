SwitchUser.setup do |config|
  config.available_users = { :user => lambda { User.order(:email) } }
  config.controller_guard = lambda { |current_user, request| current_user.try(:admin?) }
  config.redirect_path = lambda { |request, params| '/users/dashboard' }
  config.helper_with_guest = false
end
