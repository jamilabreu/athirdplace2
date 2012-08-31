class LinksController < ApplicationController
  def update  
    @link = Post.find_by(id: params[:id])  
    params[:all] = params[:post].merge!(params[:link])
    if @link.update_attributes(params[:all])  
      flash[:notice] = "Successfully updated post."  
    end  
    redirect_to posts_path  
  end 
end