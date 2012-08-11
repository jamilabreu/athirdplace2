class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  
  belongs_to :user
  belongs_to :conversation
  
  field :body, type: String
  field :read_by, type: Array
end
