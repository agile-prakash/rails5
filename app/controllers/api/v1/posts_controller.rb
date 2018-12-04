class Api::V1::PostsController < ApplicationController
  
  before_action :authenticate_with_token!, only: [:create, :update, :destroy, :index]
  before_action :set_post, only: [:update, :destroy, :show]

  def index
    # posts = Post.where(nil)
    # posts = posts.where("description ilike ?", "%#{params[:q]}%") if params[:q]
    # posts = posts.where(user: current_user.following + User.where(id: current_user.id)).order('created_at desc') unless (params[:popular] || params[:favorites])
    # posts = posts.popular if params[:popular]
    # posts = posts.favorites(current_user).order('created_at desc') if params[:favorites]
    # posts = posts.where.not(user_id: current_user.blocking.pluck(:id))
    # posts = posts.page(params[:page]).per(params[:favorites] ? 6 : 4)

    # render json: posts, meta: pagination_dict(posts)

    posts = Post.all
    posts = posts.order(updated_at: :desc).page(params[:page]).per(params[:limit])
    
    render json: posts, meta: pagination_dict(posts)
    
  end

  def create
    post = current_user.posts.build(post_params)

    if post.save
      render json: post, status: 201
    else
      render json: { errors: post.errors }, status: 422
    end
  end

  def update
    if @post.update(post_params)
      render json: @post, status: 201
    else
      render json: { errors: @post.errors }, status: 422
    end
  end

  def show
    render json: @post, root: 'post'
  end

  def destroy
    @post.destroy
    head 204
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:description, product_ids:[], videos_attributes: [:id, :_destroy, :asset_url, :post_id], photos_attributes: [:asset_url, :video_url, :id, :_destroy, labels_attributes: [:id, :_destroy, :post_id, :tag_id, :label_type, :position_top, :position_left, :name, :url, formulas_attributes: [:id, :_destroy, :service_id, :line_id, :time, :weight, :volume, :position_top, :position_left, :post_id, treatments_attributes: [:color_id, :weight, :id, :_destroy]]]])
  end

end
