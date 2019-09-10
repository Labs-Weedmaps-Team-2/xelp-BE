require 'rails_helper'

RSpec.describe 'Update Review', type: :request do
  describe 'Update /api/v1/business/:id/review/:id' do
    let(:review_params) { { review: { text: 'this place is active !!', id: 1} } }
    let(:review_params_update) { { review: { text: "this place isn't active", id: 1} } }
    let(:business) {double('Business', name: 'Awesome_Snake_Bar', id: 1, yelp_id: '282298438') }

    it 'updates a review on a business' do
      put '/api/v1/business/:id/review/:id', params: review_params_update 
      json_body = JSON.parse(response.body).deep_symbolize_keys

      expect(response).to have_http_status(200)
      expect(json_body).to include({
        text: "this place isn't active"
      })
    end
  end
end