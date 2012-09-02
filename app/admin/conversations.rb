ActiveAdmin.register Conversation do
  index do
    column :id do |conversation|
      conversation.user_ids.each do |id|
        @user = User.find_by(id: id)
        link_to @user.name, @user.facebook_url, target: "_blank"
      end
    end
  end   
end
