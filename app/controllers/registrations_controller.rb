class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :validate_user, :only => [:edit, :update]
  protected

    def after_update_path_for(resource)
      flash.delete(:notice) if flash.keys.include?(:notice)
      icon = %Q[<i class="icon-caret-right"></i>]
      link = %Q[<a href="/#{current_user.subscribed? ? 'subscriptions' : 'subscriptions/new' }">becoming a supporter</a>] 
      flash.alert = "#{icon} &nbsp;Welcome to the network! &nbsp;Please help sustain this project and keep it ad-free by #{link}.".html_safe
      root_path
    end
end