class SessionsController < Devise::SessionsController
  skip_before_filter :validate_user, :only => [:destroy]
end