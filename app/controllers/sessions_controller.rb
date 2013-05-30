class SessionsController < Devise::SessionsController
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
    return render :json => {:success => true}
  end

  def failure
    return render :json => {:success => false, :errors => flash.map{|k,v|v}}
  end
end