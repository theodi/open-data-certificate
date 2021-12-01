class SessionsController < Devise::SessionsController
  respond_to :js, :html

  def create
    if request.xhr?
      resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
      sign_in_and_redirect(resource_name, resource)
    else
      super
    end
  end

  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    flash[:notice] = flash[:notice].to_a.concat resource.errors.full_messages
    render :create, locals: {success: true}
  end

  def failure
    render :create, locals: {success: false, errors: flash.map{|k,v|v}}
  end
end
