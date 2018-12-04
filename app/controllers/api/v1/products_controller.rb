class Api::V1::ProductsController < ApplicationController

  def index
    user_id = User.where(auth_token:request.headers['Authorization']).map(&:id)
    products = Product.where(nil)
    products = products.where("name ilike ?", "%#{params[:q]}%")
    products = products.page(params[:page]).per(params[:limit]).order('id DESC')

    render json: products, user_id: user_id[0], meta: pagination_dict(products)
  end

  def show
    user_id = User.where(auth_token:request.headers['Authorization']).map(&:id) 

  	@product = Product.find(params[:id])

  	render json: @product, user_id: user_id[0]
  end

end
