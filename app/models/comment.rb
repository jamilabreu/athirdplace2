class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include AutoHtmlFor
  
  belongs_to :post
  belongs_to :user
  
  attr_accessible :body, :post_id, :user_id
  
  field :body, type: String
  
  auto_html_for :body do
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end  
end
