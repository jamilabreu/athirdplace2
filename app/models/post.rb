class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Geocoder::Model::Mongoid
  include AutoHtmlFor
  
  belongs_to :user
  has_many :comments
  has_and_belongs_to_many :communities

  attr_accessible :_type, :image, :normal_image, :large_image, :start_time, :end_time, :title, :body, :url, :url_host,
                  :user_id, :community_ids, :gender_ids, :standing_ids, :degree_ids, :field_ids, :school_ids, :city_ids,
                  :state_ids, :country_ids, :profession_ids, :company_ids, :relationship_ids, :orientation_ids, 
                  :religion_ids, :ethnicity_ids
  
  validates :body, :presence => { :message => "is blank" }, :unless => Proc.new { |a| a._type == "Link" }

  after_save :add_geo_from_user_city
  
  def add_geo_from_user_city
    if city_ids.present?
      # Add state or country
      if Community.find_by(id: city_ids.first).parent.present?
        self.communities << Community.find_by(id: city_ids.first).parent
      end
      
      # Add country if state
      if Community.find_by(id: city_ids.first).parent.parent.present?
        self.communities << Community.find_by(id: city_ids.first).parent.parent
      end
      
      # Add coordinates
      if Community.find_by(id: city_ids.first).coordinates.present? 
        self.coordinates = Community.find_by(id: city_ids.first).coordinates
      end
    end
  end
  
  field :title, type: String
  field :body, type: String
  field :url, type: String
  field :url_host, type: String
  field :image, type: String
  field :normal_image, type: String
  field :large_image, type: String
  field :start_time, type: DateTime
  field :end_time, type: DateTime
  field :coordinates, type: Array
  
  index({ coordinates: "2d" }, { min: -200, max: 200 })  
  
  auto_html_for :body do
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end
  
  # Create custom methods
  %W[ gender standing degree field school city state country profession company relationship orientation ethnicity religion ].each do |community_type|
    define_method "#{community_type}" do
      array = self.communities.filtered_by(community_type)
      array.length == 1 ? array.first : array
    end
    define_method "#{community_type}_ids" do
      self.communities.filtered_by(community_type).map(&:id)
    end
    define_method "#{community_type}_ids=" do |val| 
      self.communities.clear if community_type == "city"
      
      if community_type == "school" # Schools hack
        val.split(",").each do |school_id|
          self.communities << Community.find_by(id: school_id) if school_id != "[]" # Schools hack
        end
      
      elsif community_type == "profession" || community_type == "company"# Professions hack
        val.split(",").each do |id|
          if Community.where(id: id).exists?
            self.communities << Community.find_by(id: id) if id.present?
          else
            self.communities << Community.create!(name: id, subdomain: id.to_s.delete(" ").delete("-").parameterize, 
                                display_name: "#{id} Network", display_name: "#{id} Network", nickname: val, community_type: community_type.titleize)
          end
        end
      else  
        if val.class == Array
          val.each do |id|
            self.communities << Community.find_by(id: id) if id.present?
          end
        else
          self.communities << Community.find_by(id: val) if val.present? && val != "[]" # Cities hack
        end
      end
    end
  end

  # Relevance
  def relevance(user)
    (self.communities & user.communities).length
  end
end
