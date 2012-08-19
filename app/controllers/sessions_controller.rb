class SessionsController < Devise::SessionsController
  skip_before_filter :validate_user, :only => [:destroy]
  def destroy
    sign_out_and_redirect(resource_name)  
  end
end