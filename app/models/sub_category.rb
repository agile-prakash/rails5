class SubCategory < ApplicationRecord
  belongs_to :category
  validates_presence_of :category, :subcat_name
  # has_and_belongs_to_many :products
  # has_many_attached :image
  # belongs_to :parent_category, foreign_key: 'parent_category_id', class_name: 'Category'
end
