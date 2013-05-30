class SessionsController < Devise::SessionsController

  def create
    puts auth_options
    respond_to do |format|
      format.html do
        puts 'HERE IT IS'
        self.resource = warden.authenticate!(auth_options)
        set_flash_message(:notice, :signed_in) if is_navigational_format?
        sign_in(resource_name, resource)

        respond_with resource, :location => after_sign_in_path_for(resource)
      end

      format.js do
        self.resource = warden.authenticate(auth_options)

        if warden.authenticated?(:user)
          sign_in(resource_name, resource)
          render :json => {:success => true, :redirect => after_sign_in_path_for(resource)}
        else
          self.resource = User.new
          render :partial => 'devise/sessions/new', :remote => true, :resource => resource, :resource_name => resource_name
        end

      end
    end
  end

end
