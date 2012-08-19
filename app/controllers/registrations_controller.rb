class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :validate_user, :only => [:edit, :update]
end