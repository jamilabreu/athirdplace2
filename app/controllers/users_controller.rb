class UsersController < ApplicationController
  def frontpage
  end
  
  def index
    # Pagination
    params[:seed] ||= Random.new_seed
    srand params[:seed].to_i
    
    # Users
    community_users = @community.users.all(community_ids: params[:ids])
    @users = Kaminari.paginate_array(community_users.shuffle).page(params[:page]).per(15)
    
    # Filters
    @filters = Community.in(id: community_users.flat_map(&:community_ids).uniq - [@community.id])
  end
  
  def show
    @user = User.find(params[:id])
  end
end
