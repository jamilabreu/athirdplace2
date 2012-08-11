class Conversation
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  
  has_many :messages
  has_and_belongs_to_many :users
  
  def partner(user)
    users.ne(id: user.id).first
  end
end
