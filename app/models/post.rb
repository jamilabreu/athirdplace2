class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :body, type: String
end
