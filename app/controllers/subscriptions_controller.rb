class SubscriptionsController < ApplicationController
  def index
    @subscription = Subscription.find_by(user_id: current_user.id)
  end
  def new
    @subscription = Subscription.new
  end
  def create
    @subscription = Subscription.new(params[:subscription])
    if @subscription.save_with_payment
      redirect_to subscriptions_path, :notice => "Thank you for subscribing!"
    else
      render :new
    end  
  end
end
