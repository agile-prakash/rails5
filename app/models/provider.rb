class Provider < ApplicationRecord
  has_many :authentications
  validates_presence_of :name
end
