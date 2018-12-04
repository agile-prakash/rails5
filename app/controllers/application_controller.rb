class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  serialization_scope :view_context
  skip_before_action :verify_authenticity_token
  include Authenticable

  private

  def pagination_dict(object)
    {
      current_page: object.current_page,
      next_page: object.next_page,
      prev_page: object.prev_page, # use object.previous_page when using will_paginate
      total_pages: object.total_pages,
      total_count: object.total_count
    }
  end

  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end
end
