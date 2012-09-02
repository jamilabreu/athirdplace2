ActiveAdmin.register Conversation do
  column :user_ids do |message|
    message.user_ids.each do |id|
      @user = User.find_by(id)
      link_to @user.name, @user.facebook_url, target: "_blank"
    end
  end   
end
