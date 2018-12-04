class Post < ApplicationRecord
  belongs_to :user  
  has_and_belongs_to_many :products
  
  has_and_belongs_to_many :contacts
  validates_presence_of :user, :description
  has_and_belongs_to_many :folios, -> { distinct }
  
  has_many :likes, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true

  default_scope { includes(:likes, :videos, :comments, photos: {labels: [:tag, :formulas]}, user: [:followers, :following, :likes, :offerings, :certificates, :educations, :experiences]) }

  scope :popular, -> { where('created_at > ?', 7.days.ago).order('likes_count desc') }
  scope :favorites, -> (user) { where(id: user.likes.pluck(:post_id)) }
  
end
