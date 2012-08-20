class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :validate_user, :only => [:edit, :update]
  protected

    def after_update_path_for(resource)
      root_path
    end
end