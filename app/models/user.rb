class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  belongs_to :salon
  belongs_to :brand
  has_many :authentications, dependent: :destroy
  has_many :follower_relationships, foreign_key: :following_id, class_name: 'Follow', dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :following_relationships, foreign_key: :follower_id, class_name: 'Follow', dependent: :destroy
  has_many :following, through: :following_relationships, source: :following

  has_many :blocker_relationships, foreign_key: :blocking_id, class_name: 'Block', dependent: :destroy
  has_many :blocker, through: :blocker_relationships, source: :blocker
  has_many :blocked_relationships, foreign_key: :blocker_id, class_name: 'Block', dependent: :destroy
  has_many :blocking, through: :blocked_relationships, source: :blocking

  has_many :contacts, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :folios, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :offerings, dependent: :destroy
  has_many :services, through: :offerings
  has_many :posts, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_and_belongs_to_many :experiences
  has_and_belongs_to_many :certificates


  accepts_nested_attributes_for :salon, allow_destroy: true
  accepts_nested_attributes_for :brand, allow_destroy: true
  accepts_nested_attributes_for :educations, allow_destroy: true
  accepts_nested_attributes_for :offerings, allow_destroy: true

  enum account_type: [:consumer, :stylist, :ambassador, :owner] 

  before_create :generate_authentication_token!

  before_validation :set_default_account_type

  after_create :follow_autofollows

  default_scope { includes(:likes, :favourites, :offerings, :certificates, :educations, :experiences) }

  scope :search, -> (query) {
    includes(:salon, :brand, :services, :experiences)
      .where('(users.first_name ilike ?) or (users.last_name ilike ?) or (users.description ilike ?) or (salons.name ilike ?) or (brands.name ilike ?) or (services.name ilike ?) or (experiences.name ilike ?)', "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")
      .references(:salon)
    }

  def unread_messages_count
    Conversation.participant(self).map {|c| c.messages.where(read: false).where('user_id != ?', self.id).length }.sum
  end

  def follow_autofollows
    User.where(auto_follow: true).each do |user|
      Follow.create(follower: self, following: user)
    end
  end

  def friends
    following & followers
  end

  def following?(user)
    self.following.include?(user)
  end

  def followers?(user)
    self.followers.include?(user)
  end

  def set_default_account_type
    self.account_type ||= 'consumer'
  end

  def generate_authentication_token!
    loop do
      self.auth_token = Devise.friendly_token
      break unless self.class.exists?(auth_token: auth_token)
    end
  end

  def self.validate_facebook_token(token)
    Koala::Facebook::API.new(token).get_object('me?fields=id,name,first_name,last_name,email,friends')
  rescue
    false
  end

  def generate_social_authentication!(name, token, secret=nil, uid_name=nil)
    Authentication.create_with(user: self, token: token, secret: secret, facebook_id: uid_name, provider: Provider.find_by(name: name)).find_or_create_by(user: self, provider: Provider.find_by(name: name))
  end

  def self.validate_instagram_token(token)
    Instagram.client(access_token: token).user
  rescue
    false
  end

  def self.create_from_social(response)
    password = Devise.friendly_token
    name = response['full_name'] ? response['full_name'] : response['name']
    user = create(email: response['email'] ? response['email'] : "socialemail#{rand(0..83293)}@example.com", first_name: name.split(' ').first, last_name: name.split(' ').last, password: password, password_confirmation: password) rescue User.new
    return user.valid? ? user : false
  end
end
