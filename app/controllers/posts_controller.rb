class PostsController < ApplicationController
  require 'open-uri'
  def index
    # Posts
    user_posts = Post.in(community_ids: current_user.community_ids).all(community_ids: params[:ids])
    
    # FIXME: Calculate post relevance on the fly with MongoDB 'aggregate' method
    if params[:relevance]
      @posts = {}
      current_user.community_ids.length.downto(1).each do |i|
        user_posts.each do |post|
          if post.relevance(current_user) == i
            @posts[i].present? ? @posts[i] << post : @posts[i] = post.to_a
          end
        end
      end
    else
      @posts = user_posts.desc(:created_at)
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
  
  def edit
    @post = Post.find_by(id: params[:id])
    redirect_to posts_path unless @post.user == current_user || current_user == User.find_by(email: "abreu.jamil@gmail.com")
  end
  
  def update  
    @post = Post.find_by(id: params[:id])  
    if @post.update_attributes(params[:post])  
      flash[:notice] = "Successfully updated post."  
    end  
    redirect_to posts_path  
  end  
 
  
  def preview
    url = URI.extract(params[:q]).join
    if url.present? && url.include?("facebook.com/events/")
      event_id = url.split("/events/").last.split("/").first
      response = HTTParty.get("https://graph.facebook.com/#{event_id}/", :query => {:access_token => current_user.oauth_token} )
      unless response.parsed_response["error"].present?
        @url = url
        @name = response.parsed_response["name"]
        @body = response.parsed_response["description"]
        
        @image = "https://graph.facebook.com/#{event_id}/picture"
        @normal_image = "https://graph.facebook.com/#{event_id}/picture?type=normal"
        @large_image = "https://graph.facebook.com/#{event_id}/picture?type=large"
        
        @start_time = DateTime.parse response.parsed_response["start_time"]
        @end_time = DateTime.parse response.parsed_response["end_time"]
      end
    elsif url.present?
      # Only allow facebook event URLs for now
      nil
=begin
      begin
        page = Nokogiri::HTML(open(url))
        @url = url
        @host = URI.parse(url).host.gsub("www.", "")
        @title = page.title.split.join(" ")
        # Description
        input = params[:q].gsub(url, "")
        meta_description = page.css("meta[name='description']").first["content"]
        description = input.blank? && meta_description.present? ? meta_description : input
        @description = description.html_safe
      rescue
        nil
      end
=end
    end
  end
end
