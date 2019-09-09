require 'rails_helper'

RSpec.describe "Create Business", type: :request do
  describe "Create /api/v1/business" do
    let(:business_params) { { business: { name: "a_business", address: '5511 Hood Ave', city: 'long beach', state: 'ca', zipcode: '91801', } } }

    it "creates a new business" do
      post "/api/v1/business", params: business_params
      json_body = JSON.parse(response.body).deep_symbolize_keys

      expect(response).to have_http_status(201)

    end
  end
end
