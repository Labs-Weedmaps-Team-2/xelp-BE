require 'rails_helper'

RSpec.describe "Get User", type: :request do

  context 'with omniAuth' do 
    describe 'Create /api/v1/users' do
      # create
    end
  end
  context 'without omniAuth' do
    describe "Create /api/v1/users" do
      let(:user_params) { { user: { email: "john@example.com",  provider: "github", uid: '36726553', username: 'johnjoe' } } }
  
      it "creates a new user" do
        post api_v1_users_path, params: user_params
        json_body = JSON.parse(response.body).deep_symbolize_keys
  
        expect(response).to have_http_status(201)
        expect(json_body).to include({
          email: "john@example.com",
          username: 'johnjoe'
        })
      end
    end
  end
end
