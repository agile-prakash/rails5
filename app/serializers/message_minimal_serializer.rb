class MessageMinimalSerializer < ActiveModel::Serializer
  attributes :id, :user, :created_at, :conversation_id, :body, :post, :url, :read

  def user
    UserMinimalSerializer.new(object.user).serializable_hash if object.user
  end

  def post
    PostMinimalSerializer.new(object.post, {scope: scope}).serializable_hash if object.post
  end
end
