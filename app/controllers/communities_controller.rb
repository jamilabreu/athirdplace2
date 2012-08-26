class CommunitiesController < ApplicationController
  skip_before_filter :validate_user, :only => [:index]
  def index
    if params[:schools]
      @communities = Community.filtered_by(:school).where(name: /#{params[:schools]}/i)
    elsif params[:cities]
      @communities = Community.filtered_by(:city).where(name: /#{params[:cities]}/i)
    elsif params[:professions]
      professions = Community.filtered_by(:profession).where(name: /#{params[:professions]}/i) 
      if professions.blank?
        @communities = [{id: params[:professions].titlecase, name: params[:professions].titlecase}]
      else
        @communities = professions
      end
    elsif params[:companies]
      companies = Community.filtered_by(:company).where(name: /#{params[:companies]}/i) 
      if companies.blank?
        @communities = [{id: params[:companies].titlecase, name: params[:companies].titlecase}]
      else
        @communities = companies
      end    
    elsif params[:school]
      @communities = Community.any_in(id: current_user.school_ids)
    elsif params[:city]
      @communities = Community.find_by(id: current_user.city_ids.first)
    elsif params[:profession]
      @communities = Community.any_in(id: current_user.profession_ids)
    elsif params[:company]
      @communities = Community.any_in(id: current_user.company_ids)      
    end
    respond_to do |format|
      format.json { render json: @communities, callback: params[:callback] }
    end    
  end
end