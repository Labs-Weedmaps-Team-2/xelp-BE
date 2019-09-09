require 'rails_helper'

RSpec.describe "Get Business", type: :request do
  describe "GET /api/v1/business/:id" do
    let(:business) { Business.create!(name: "Super Cool Business") }

    it "gets the business" do
      get api_v1_business_path(business)
      json_body = JSON.parse(response.body).deep_symbolize_keys

      expect(response).to have_http_status(200)
      expect(json_body).to include({
        name: "Super Cool Business"
      })
    end
  end
end
