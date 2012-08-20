module ApplicationHelper
  def community_name
    @community ? @community.display_name : "thirdplace"
  end
  def tagline
    @community ? "a global support network for #{@community.name.pluralize.downcase}" : "a global support network for the communities you care about"
  end
  
  # Page Helper
  def home_page
    params[:controller] == "users" && params[:action] == "home"
  end
  def users_page
    params[:controller] == "users" && params[:action] == "index"
  end
  def edit_page
    params[:controller] == "registrations" && params[:action] == "edit"
  end
  def conversations_page
    params[:controller] == "conversations" && params[:action] == "index"
  end  
  def subscriptions_page
    params[:controller] == "subscriptions"
  end
  
  # Filter Helpers
  def selected?(community)
    params[:ids].present? && params[:ids].include?(community.id)
  end
  
  def set_params!(community)
    selected?(community) ? (params[:ids] - [community.id]) : (params[:ids].to_a | [community.id])
  end
  
  # Conversation helpers
  def conversation_exists?(user)
    Conversation.all(user_ids: [user.id, current_user.id]).present?
  end
  def conversation_id(user)
    Conversation.all(user_ids: [user.id, current_user.id]).first.id
  end
end
