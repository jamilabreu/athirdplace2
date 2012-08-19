class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    # raise request.env["omniauth.auth"].to_yaml
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      user.update_attribute(:friend_ids, user.facebook.get_connections("me", "friends").map{|item|item["id"]}.uniq)
      #flash.notice = "Signed in!"
      sign_in user
      redirect_to request.env["omniauth.origin"] || "/"
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end
  alias_method :facebook, :all
end