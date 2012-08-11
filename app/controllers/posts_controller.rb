class PostsController < ApplicationController
  def index
    # Posts
    community_posts = @community.posts.all(community_ids: params[:ids])
    @posts = Kaminari.paginate_array(community_posts.limit(2)).page(params[:page]).per(15)
    
    # Filters
    @filters = Community.in(id: community_posts.flat_map(&:community_ids).uniq - [@community.id])    
  end
end
