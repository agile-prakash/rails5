class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy, :show, :posts, :folios]
  before_action :authenticate_with_token!, only: [:index]

  def index
    users = User.where(nil)
    users = users.search(params[:q]) if params[:q]
    users = users.where(account_type: params[:account_type]) if params[:account_type]
    users = users.where.not(id: current_user.blocking.pluck(:id))
    users = users.order(updated_at: :desc).page(params[:page]).per(params[:limit])
    
    render json: users, meta: pagination_dict(users)
  end

  def show
    render json: @user
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def user_likes
    likes = Like.where(user_id: params[:id])

    render json: likes, status: 201
  end

  def user_favourites  
    user_id = User.where(auth_token:request.headers['Authorization']).map(&:id)   
    favourites = Favourite.where(user_id: params[:id])

    render json:favourites, user_id: user_id[0], status: 201
  end

  def update
    if @user.update(user_params)
      render json: @user, status: 201
    else
      render json: { errors: @user.errors }, status: 422
    end
  end

  def destroy
    @user.destroy
    render json: { message: "User Deleted" }, status: 201
    head 204
  end

  def posts
    posts = @user.posts.order('created_at desc').page(params[:page]).per(params[:limit])
    render json: posts, meta: pagination_dict(posts)
  end

  def folios
    folios = @user.folios.order('created_at desc').page(params[:page]).per(params[:limit])
    render json: folios, meta: pagination_dict(folios)
  end

  def invite_users
    emails = params[:emails]
    emails.each do |email|
      UserMailer.send_invitation_email(email).deliver_now
    end
    render json: { message: "Invitation send successfully."}, status: 200
  end

  private

  def user_params
    params.require(:user).permit(:facebook_token, :twitter_token, :instagram_token, :default_pinterest_board, :pinterest_token, :email, :password, :password_confirmation, :account_type, :first_name, :last_name, :description, :avatar_url, :avatar_cloudinary_id, :share_facebook, :share_twitter, :share_instagram, :share_pinterest, :share_tumblr, :prof_desc, :years_exp, :salon_id, :career_opportunity, brand_attributes: [:id, :_destroy, :name, :info, :address, :city, :state, :zip, :website, :phone], salon_attributes: [:name, :info, :address, :city, :state, :zip, :website, :phone], educations_attributes: [:name, :year_from, :year_to, :degree_id, :user_id, :website, :id, :_destroy], offerings_attributes: [:user_id, :category_id, :service_id, :price, :id, :_destroy], certificate_ids: [], experience_ids: [])
  end

  def set_user
    @user = User.find(params[:id])
  end

end
