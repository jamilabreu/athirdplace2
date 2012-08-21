class Conversation
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  
  has_many :messages
  has_and_belongs_to_many :users
  
  def partner(user)
    users.ne(id: user.id).first
  end
  
  # Check for unread messages
  def has_unread_by(user)
    Message.any_in(conversation_id: id).ne(read_by: user.id).present?
  end  
end
