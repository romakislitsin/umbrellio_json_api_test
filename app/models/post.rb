class Post < ApplicationRecord
  belongs_to :user
  has_many :ratings

  scope :by_top_rated, -> (count) { self.where('average_rating > ?', 0).order(average_rating: :desc).limit(count) }

  def check_average_rating
    ratings ? ratings.average(:rate).to_f.round(2) : 0.0
  end

  def update_average_rating
    update_attributes(average_rating: self.check_average_rating)
  end
end
