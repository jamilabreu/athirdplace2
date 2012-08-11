class Subscription
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  
  belongs_to :user
  
  field :stripe_customer_token, type: String
  
  attr_accessor :stripe_card_token
  
  def save_with_payment
    if valid?
      user = User.find_by(id: user_id)
      customer = Stripe::Customer.create(card: stripe_card_token, plan: 1, email: user.email, description: "#{user.name} #{user.id}")
      self.stripe_customer_token = customer.id
      self.user = user
      #Stripe::Charge.create(:amount => 2000, :currency => "usd", :customer => stripe_customer_token, :description => "text")
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end
end
