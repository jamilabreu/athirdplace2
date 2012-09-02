ActiveAdmin.register Message do
  index do                            
    column :body
    column :user_id do |message|
      @user = User.find_by(message.user_id)
      link_to @user.name, @user.facebook_url, target: "_blank"
    end   
    column :read_by do |message|
      message.read_by.each do |id|
        @user = User.find_by(message.user_id)
        link_to @user.name, @user.facebook_url, target: "_blank"
      end
    end  
    default_actions                   
  end      
end
