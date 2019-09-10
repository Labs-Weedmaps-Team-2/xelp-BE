require 'rails_helper'

RSpec.describe "Edit Review", type: :request do
  let(:user) {User.create!(id: 1, email: '@gmail.com', username:'joedoe')}

  let(:business) {Business.create!(name: "SuperCoolBusiness", id: 1)}

  let(:review) {Review.create!(text: "I love this place", id: 1, rating: '5', user_id: user.id, business_id: business.id,)}
  
  let(:review_params) {{review: {text: "I dont like this place anymore ...", rating: '1', id: 1}}}

  describe 'Update /api/v1/business/:id/review/:review_id' do
    it "updates a review" do
      patch "/api/v1/business/:id/review/:review_id" , params: review_params
      json_body = JSON.parse(response.body)
      puts json_body
      expect(response).to have_http_status(200)
    end
  end
end
