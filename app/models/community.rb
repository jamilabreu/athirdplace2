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
  field :address, type: String
  field :coordinates, type: Array
  
  index({ coordinates: "2d" }, { min: -200, max: 200 })
  
  scope :filtered_by, lambda { |community_type| where(community_type: community_type.to_s.titleize).asc(:name) }

  def as_json(options={})
    { :id => self._id, :name => self.dropdown_name }
  end

  def name_and_parent(type)
    if community_type == "City"
      if parent.parent.name == "United States"
        type == :dropdown ? "#{name}, #{parent.name}" : "#{name}, #{parent.mod_state_code}"
      else
        type == :dropdown ? "#{name}, #{parent.parent.name}" : "#{name}, #{parent.parent.country_code}"
      end
    else
      name
    end
  end
  
  def mod_state_code
    state_code.include?("US-") ? state_code.delete("US-") : state_code
  end
  
  def dropdown_name
    name_and_parent(:dropdown)
  end

  def filter_name
    name_and_parent(:filter)
  end  
end
