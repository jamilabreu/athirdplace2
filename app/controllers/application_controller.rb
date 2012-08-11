class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_community
  before_filter :validate_user
  
  private
  def load_community
    @community = Community.find_by(subdomain: request.subdomain) if request.subdomain.present?
  end
  def validate_user
    redirect_to edit_user_registration_path if user_signed_in? && current_user.invalid?
  end
end
