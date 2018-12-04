class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :is_favourite, :price, :quantity, :favourites_count, :link_url, :image_url, :cloudinary_url, :created_at, :categories
  belongs_to :tag 

	def is_favourite
	   object.favourites.pluck(:user_id).include?(current_user_id)	   
    end

	def current_user_id
	    @instance_options[:user_id]
  	end

end
