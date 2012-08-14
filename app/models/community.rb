class Community
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Tree
  include Geocoder::Model::Mongoid

  has_and_belongs_to_many :users
  
  field :name, type: String
  field :subdomain, type: String
  field :display_name, type: String
  field :community_type, type: String
  field :state, type: String
  field :state_code, type: String
  field :country, type: String
  field :country_code, type: String
  field :coordinates, type: Array
  field :name_singular, type: String
  field :name_plural, type: String
  
  scope :filtered_by, lambda { |community_type| where(community_type: community_type.to_s.titleize).asc(:name) }

  def name_and_country(x)
    country == "United States" ? "#{name}, #{x == :filter ? state_code : state}" : "#{name}, #{country}"
  end
  def filter_name
    community_type == "City" ? name_and_country(:filter) : name
  end
  def dropdown_name
    community_type == "City" ? name_and_country(:dropdown) : name
  end  
end
