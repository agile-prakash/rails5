class Product < ApplicationRecord
  belongs_to :tag
  
  has_and_belongs_to_many :posts
  belongs_to :user
  
  # belongs_to :subcategory, foreign_key: 'subcategory_id', class_name: 'Category'  
  has_and_belongs_to_many :categories

  validates_presence_of :name, :tag
  has_many :favourites, dependent: :destroy
  after_create :upload_to_cloudinary

  def upload_to_cloudinary
    if image_url
      begin
        image = Cloudinary::Uploader.upload(image_url)
        # :nocov:
        update(cloudinary_url: image['url'])
        # :nocov:
      rescue
      end
    end
  end
end
