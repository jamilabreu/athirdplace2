class EventsController < ApplicationController
  def update  
    @event = Post.find_by(id: params[:id])
    params[:all] = params[:post].merge!(params[:event])
    if @event.update_attributes(params[:all])  
      flash[:notice] = "Successfully updated post."  
    end  
    redirect_to posts_path  
  end 
end