class Review < ApplicationRecord
  belongs_to :user
  belongs_to :business

  def self.create_from_review(review, yelp_id)
    @business = review.create_business!(name: 'ayyyee', yelp_id: yelp_id)
    @business
  end

end
