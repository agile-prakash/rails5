class Favourite < ApplicationRecord
  belongs_to :product, counter_cache: true
  belongs_to :user
  validates_presence_of :product, :user
  validates_uniqueness_of :product, scope: :user
  # after_create :notify_owner
  # has_many :notifications

  # def notify_owner
  #   Notification.create!(user: post.user, body: "#{user.first_name} #{user.last_name} liked your post.", notifiable: self)
  # end
  
end
