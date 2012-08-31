class EventsController < ApplicationController
  def update  
    @post = Post.find_by(id: params[:id])  
    if @post.update_attributes(params[:post])  
      flash[:notice] = "Successfully updated post."  
    end  
    redirect_to posts_path  
  end 
end