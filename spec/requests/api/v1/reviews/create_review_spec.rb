require 'rails_helper'

RSpec.describe "Get Review", type: :request do
  describe "Create /api/v1/business/:id/review" do

    let(:review_params) { { review: { text: "this place is active !!", id: 1 } } }
    let(:business) { double("Business", name: "Awesome_Snake_Bar", id: 1, yelp_id: '282298438') }

    it "creates a new review that belongs to a business" do
      post '/api/v1/business/:id/review', params: review_params
      json_body = JSON.parse(response.body).deep_symbolize_keys

      expect(response).to have_http_status(201)
      expect(json_body).to include({
        text: "this place is active !!"
      })
    end
  end
end
