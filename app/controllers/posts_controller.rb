class PostsController < ApplicationController
  def index
    # Posts
    @posts = {}
    user_posts = Post.in(community_ids: current_user.community_ids).all(community_ids: params[:ids])
    
    current_user.community_ids.length.downto(1).each do |i|
      user_posts.each do |post|
        if post.relevance(current_user) == i
          @posts[i].present? ? @posts[i] << post : @posts[i] = post.to_a
        end
      end
    end
    
    # Filters
    @filters = Community.in(id: user_posts.flat_map(&:community_ids).uniq - [@community.id]).asc(:name)
  end
  
  def new
    @post = Post.new
  end
  def create
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.communities << @community
    
    if @post.save
      redirect_to posts_path
    else
      render :new
    end
  end
  
  def preview
    event_url = URI.extract(params[:q]).join
    if event_url.present? && event_url.include?("facebook.com/events/")
      event_id = event_url.split("/events/").last.split("/").first
      response = HTTParty.get("https://graph.facebook.com/#{event_id}/", :query => {:access_token => current_user.oauth_token} )
      unless response.parsed_response["error"].present?
        @name = response.parsed_response["name"]
        @body = response.parsed_response["description"]
        
        @image = "https://graph.facebook.com/#{event_id}/picture"
        @normal_image = "https://graph.facebook.com/#{event_id}/picture?type=normal"
        @large_image = "https://graph.facebook.com/#{event_id}/picture?type=large"
        
        @start_time = DateTime.parse response.parsed_response["start_time"]
        @end_time = DateTime.parse response.parsed_response["end_time"]
      end
    end
  end
end
