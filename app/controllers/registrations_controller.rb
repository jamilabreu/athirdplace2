class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :validate_user, :only => [:edit, :update]

  def edit
    @alumni_id = Community.find_by(name: 'Alumni').id
  end
end