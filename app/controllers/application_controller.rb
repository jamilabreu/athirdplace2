class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :validate_user
  before_filter :load_community
  
  
  private
  def validate_user
    if user_signed_in? && current_user.invalid?
      redirect_to edit_user_registration_path, notice: "#{current_user.first_name} - please share a bit about yourself with the community before entering."
    end
  end
  def load_community
    begin
      @community = Community.find_by(subdomain: request.subdomain) if request.subdomain.present?
    rescue
      redirect_to root_url(subdomain: false)
    end
  end
end
