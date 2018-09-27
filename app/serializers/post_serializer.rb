class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :average_rating, :user_id, :user_ip

  def by_rating
    {
      title: @post.title,
      content: @post.content
    }
  end
end