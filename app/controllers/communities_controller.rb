class CommunitiesController < ApplicationController
  skip_before_filter :validate_user, :only => [:index]
  def index
    if params[:schools]
      @communities = Community.filtered_by(:school).where(name: /#{params[:schools]}/i)
    elsif params[:cities]
      @communities = Community.filtered_by(:city).where(name: /#{params[:cities]}/i)
    elsif params[:school]
      @communities = Community.any_in(id: current_user.school_ids)
    elsif params[:city]
      @communities = Community.find_by(id: current_user.city_ids.first)
    end
    respond_to do |format|
      format.json { render json: @communities, callback: params[:callback] }
    end    
  end
end