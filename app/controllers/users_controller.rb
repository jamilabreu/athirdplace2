class UsersController < ApplicationController
  skip_before_filter :authenticate_user!
  def home
    @communities = Community.any_in(id: User.all.flat_map(&:community_ids).uniq.compact, community_type: ["School", "Ethnicity", "Field"]).asc(:name)
  end
  
  def index
    # Randomness
    params[:seed] ||= Random.new_seed
    srand params[:seed].to_i
    
    # Users
    community_users = @community.users.all(community_ids: params[:ids]).shuffle
    # Show particular user first
    community_users.unshift User.find_by(id: params[:id]) if params[:id] && params[:ids].blank?
    # Paginate
    @users = Kaminari.paginate_array(community_users).page(params[:page]).per(15)
    
    # Filters
    @filters = Community.in(id: community_users.flat_map(&:community_ids).uniq - [@community.id]).asc(:name)
  end
  
  def show
    @user = User.find(params[:id])
  end
end
