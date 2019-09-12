class Review < ApplicationRecord
  belongs_to :user
  belongs_to :business
  has_many_attached :photos

  def self.reviewable(id, user_id)
    @existing_review = Review.find_by(user_id: user_id, business_id: id)|| nil
    if @existing_review
      return false
    else
      true
    end
  end
end
