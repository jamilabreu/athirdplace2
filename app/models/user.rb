class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Geocoder::Model::Mongoid
  include ActionView::Helpers::TextHelper # Pluralize  
  # include Mongoid::Versioning
  
  has_and_belongs_to_many :communities
  has_and_belongs_to_many :conversations
  has_many :messages
  has_one :subscription
  
  attr_accessible :email, :provider, :uid, :oauth_token, :name, :first_name, :last_name, :image, :normal_image, 
                  :large_image, :facebook_url, :show_facebook_url, :twitter_name, :blog_url, :bio, :profession, 
                  :company, :gender, :message_ids, :friend_ids, :coordinates, :community_ids, :gender_ids, 
                  :standing_ids, :degree_ids, :field_ids, :school_ids, :city_ids, :state_ids, :country_ids, 
                  :relationship_ids, :orientation_ids, :religion_ids, :ethnicity_ids
                  
  after_update :add_geo_from_user_city
  
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
        self.coordinates =  Community.find_by(id: city_ids.first).coordinates
      end
    end
  end
    
  %W[ gender standing field school city ].each do |community_type|
    validates community_type.to_sym, :presence => { :message => "is blank" }, :on => :update
  end
                   
  # Include default devise modules. Others available are: :token_authenticatable, :confirmable, :lockable, and :timeoutable
  # devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :registerable, :validatable, :omniauthable, :trackable
  
  field :email, type: String
  field :encrypted_password, type: String
  field :provider, type: String
  field :uid, type: String
  field :oauth_token, type: String
  field :name, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :image, type: String
  field :normal_image, type: String
  field :large_image, type: String
  field :facebook_url, type: String
  field :show_facebook_url, type: Boolean
  field :twitter_name, type: String
  field :blog_url, type: String
  field :bio, type: String
  field :profession, type: String
  field :company, type: String
  field :gender, type: String
  field :coordinates, type: Array
  field :friend_ids, type: Array
  field :coordinates, type: Array
  
  index({ coordinates: "2d" }, { min: -200, max: 200 })  
  ## Database authenticatable
  # field :email,              :type => String, :null => false, :default => ""
  # field :encrypted_password, :type => String, :null => false, :default => ""

  ## Recoverable
  # field :reset_password_token,   :type => String
  # field :reset_password_sent_at, :type => Time

  ## Rememberable
  # field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

  # Create custom methods
  %W[ gender standing field school city state country degree relationship orientation ethnicity religion ].each do |community_type|
    define_method "#{community_type}" do
      array = self.communities.filtered_by(community_type)
      array.length == 1 ? array.first : array
    end
    define_method "#{community_type}_ids" do
      self.communities.filtered_by(community_type).map(&:id)
    end
    define_method "#{community_type}_ids=" do |val| 
      self.communities.clear if community_type == "gender"
      if community_type == "school" # Schools hack
        val.split(",").each do |school_id|
          self.communities << Community.find_by(id: school_id) if school_id != "[]" # Schools hack
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
  
  # Omniauth authentication
  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.oauth_token = auth.credentials.token
      user.email = auth.info.email
      user.name = auth.info.name
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.image = auth.info.image
      user.normal_image = "http://graph.facebook.com/#{auth.uid}/picture?type=normal"
      user.large_image = "http://graph.facebook.com/#{auth.uid}/picture?type=large"
      user.facebook_url = auth.extra.raw_info.link
      user.gender = auth.extra.raw_info.gender
      user.community_ids = auth.extra.raw_info.gender.titleize == "Female" ? [Community.find_by(name: "Female").id.to_s] : [Community.find_by(name: "Male").id.to_s]
    end
  end
  
  # Check subscription status
  def subscribed?
    Subscription.where(user_id: id).exists?
  end

  # Koala
  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil # or consider a custom null object
  end
  
  # Mutual friends
  def mutual_friends(user)
    unless self.id == user.id
      mutual_friends_count = (user.friend_ids & self.friend_ids).length
      pluralize(mutual_friends_count, "mutual friend") if mutual_friends_count > 0
    end
  end

  # Network friends
  def network_friends(user)
    network_friends_count = (user.friend_ids & User.all.flat_map(&:uid).uniq).length
    pluralize(network_friends_count, "friend") + " in this network" if network_friends_count > 0
  end
  
  # Validation error on signup
  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end
  
  # Don't require password on signup or update
  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
end
