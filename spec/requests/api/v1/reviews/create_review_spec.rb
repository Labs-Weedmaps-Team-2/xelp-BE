require 'rails_helper'

RSpec.describe "Create Review", type: :request do
  let(:user) {User.create!(id: 1, email: '@gmail.com', username:'joedoe')}

  let(:business) {Business.create!(name: "SuperCoolBusiness", id: 1)}

  let(:review_params) {{review: {text: "wow this place is always full of people", rating: '5', user_id: user.id, business_id: business.id}}}

  describe 'Create /api/v1/business/:id/review' do
    it "creates a review" do
      post "/api/v1/business/:id/review" , params: review_params
      json_body = JSON.parse(response.body).deep_symbolize_keys
      expect(response).to have_http_status(201)
    end
  end
end
