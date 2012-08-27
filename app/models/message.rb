class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  
  belongs_to :user
  belongs_to :conversation
  
  validates :body, :presence => true
  
  field :body, type: String
  field :read_by, type: Array
  
  scope :unread_by, lambda { |user| ne(read_by: user.id) }

end
