require 'rails_helper'

RSpec.describe Api::V1::ReviewController, type: :controller do
  describe 'review params restrictions' do
    it 'should restrict params' do
      params = {
        review: {
          user_id: 1, text: 'Very Bad', rating: 4, business_id:2, photos: []
        }
      }
      should permit(:text, :rating, :user_id, :business_id, :photos=>[]).
        for(:create, params: params).
        on(:review)
    end
  end
  describe 'is reviewable' do
    review = Review.new
    it 'should be false' do
      expect(review.reviewable).to be(false)
    end
  end
  describe "GET index" do
    let(:review) {Review.create()}
    it "sets @reviews" do
      get :index
      expect(response.body).to include(true)
    end
  end

end
