ActiveAdmin.register User do
   index do                            
    column :image do |user|
      link_to image_tag(user.image), users_path(id: user), target: "_blank"
    end
    column :name do |user|
      link_to user.name, user.facebook_url, target: "_blank"
    end
    column :email                     
    column :current_sign_in_at        
    column :last_sign_in_at           
    column :sign_in_count             
    default_actions                   
  end                                 

  filter :email  
end
