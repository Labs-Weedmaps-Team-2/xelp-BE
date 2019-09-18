
require "rails_helper"

RSpec.describe 'Update Review', type: :request do
  describe 'Update /api/v1/business/:id/review/:id' do
    let(:review_params) { { review: { text: 'this place is active !!', id: 1} } }
    let(:review_params_update) { { review: { text: "this place isn't active", id: 1} } }
    let(:business) { double('Business', name: 'Awesome_Snake_Bar', id: 1, yelp_id: '282298438') }

    it 'updates a review on a business' do
      put '/api/v1/business/:id/review/:id', params: review_params_update 
      json_body = JSON.parse(response).deep_symbolize_keys

      expect(response).to have_http_status(200)
      expect(json_body).to include({
        text: "this place isn't active"
      })
    end
  end
end
# require 'rails_helper'

# RSpec.describe "Edit Review", type: :request do
#   let(:user) {User.create!(id: 1, email: '@gmail.com', username:'joedoe')}

#   let(:business) {Business.create!(name: "SuperCoolBusiness", id: 1)}

#   let(:review) {Review.create!(text: "I love this place", id: 1, rating: '5', user_id: user.id, business_id: business.id,)}
  
#   let(:review_params) {{review: {text: "I dont like this place anymore ...", rating: '1', id: 1}}}

#   describe 'Update /api/v1/business/:id/review/:review_id' do
#     it "updates a review" do
#       patch "/api/v1/business/:id/review/:review_id" , params: review_params
#       json_body = JSON.parse(response.body)
#       puts json_body
#       expect(response).to have_http_status(200)
#     end
#   end
# end
