class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :user

  def user
    UserSerializer.new(object.user, {scope: scope}).serializable_hash
  end
end
