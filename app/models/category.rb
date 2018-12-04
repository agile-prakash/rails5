class Category < ApplicationRecord
  validates_presence_of :name
  has_and_belongs_to_many :products
  has_many :sub_categories

  # has_many_attached :image 

  # has_many_attached :image
  # belongs_to :parent_category, foreign_key: 'parent_category_id', class_name: 'Category'
end
