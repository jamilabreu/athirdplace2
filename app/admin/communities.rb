ActiveAdmin.register Community do
  index do                            
    column :name do |community|
      link_to community.name, users_url(subdomain: community.subdomain), target: "_blank"
    end
    column :community_type          
    default_actions                   
  end     
end
