class TopRatedPostsSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :average_rating
end