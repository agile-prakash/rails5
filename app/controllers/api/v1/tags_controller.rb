class Api::V1::TagsController < ApplicationController
  before_action :set_tag, only: [:show, :posts]
  before_action :authenticate_with_token!, only: [:index, :posts]

  def index
    blocked_posts_ids = Post.where(user_id: current_user.blocking.pluck(:id)).pluck(:id)
    blocked_photos_id = Photo.where(post_id: blocked_posts_ids).pluck(:id)
    tags = Tag.includes(:photos)
      .where.not(photos: { id: nil })
      .where.not(photos: { id: blocked_photos_id })
    tags = tags.where("tags.name ilike ?", "%#{params[:q].gsub('#', '')}%") if params[:q]
    tags = tags.popular if params[:popular]
    tags = tags.page(params[:page]).per(3)
    render json: tags, meta: pagination_dict(tags)
  end

  def exact
    tag = Tag.find_by(name: params[:q])
    render json: tag
  end

  def show
    render json: @tag
  end

  def posts
    posts = Post.where(id: @tag.photos.pluck(:post_id))
      .where.not(user_id: current_user.blocking.pluck(:id))
      .order('created_at desc').page(params[:page]).per(params[:limit])
    render json: posts, include: '**', meta: pagination_dict(posts)
  end

  def create
    tag = Tag.new(tag_params)
    if tag.save
      render json: tag, status: 201
    else
      render json: { errors: tag.errors}, status: 422
    end
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end

end
