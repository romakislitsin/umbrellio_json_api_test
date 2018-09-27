class RatingSerializer < ActiveModel::Serializer
  attributes :id, :post_id, :rate
end