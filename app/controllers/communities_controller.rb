class CommunitiesController < ApplicationController
  skip_before_filter :validate_user, :only => [:index]
  def index
    # All
    if params[:schools]
      @communities = Community.filtered_by(:school).where(name: /#{params[:schools]}/i)
      @communities += @community.to_a if @community && @community.community_type == "School"
    elsif params[:cities]
      @communities = Community.filtered_by(:city).where(name: /#{params[:cities]}/i)
      @communities += @community.to_a if @community && @community.community_type == "City"
    elsif params[:professions]
      professions = Community.filtered_by(:profession).where(name: /#{params[:professions]}/i) 
      if professions.blank?
        @communities = [{id: params[:professions].titlecase, name: params[:professions].titlecase}]
      else
        @communities = professions
      end
      @communities += @community.to_a if @community && @community.community_type == "Profession"
    elsif params[:companies]
      companies = Community.filtered_by(:company).where(name: /#{params[:companies]}/i) 
      if companies.blank?
        @communities = [{id: params[:companies].titlecase, name: params[:companies].titlecase}]
      else
        @communities = companies
      end
      @communities += @community.to_a if @community && @community.community_type == "Company"
    # current_user
    elsif params[:school]
      @communities = Community.in(id: current_user.school_ids)
    elsif params[:city]
      @communities = Community.find_by(id: current_user.city_ids.first)
    elsif params[:profession]
      @communities = Community.in(id: current_user.profession_ids)
    elsif params[:company]
      @communities = Community.in(id: current_user.company_ids) 
    # Post 
    elsif params[:post_school]
      @post = Post.find_by(id: params[:post_id])
      @communities = Community.in(id: @post.school_ids)
    elsif params[:post_city]
      @post = Post.find_by(id: params[:post_id])
      @communities = Community.find_by(id: @post.city_ids.first)
    elsif params[:post_profession]
      @post = Post.find_by(id: params[:post_id])
      @communities = Community.in(id: @post.profession_ids)
    end
    respond_to do |format|
      format.json { render json: @communities, callback: params[:callback] }
    end    
  end
end