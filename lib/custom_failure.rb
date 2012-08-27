class CustomFailure < Devise::FailureApp
  def redirect_url
    #return super unless [:worker, :employer, :user].include?(scope) #make it specific to a scope
    flash.delete(:alert) if flash.keys.include?(:alert)
    root_path
  end

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end