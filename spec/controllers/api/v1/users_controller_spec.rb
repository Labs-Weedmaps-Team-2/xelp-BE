require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  # Index, show
  describe "GET index" do
    it "should return a list of users in db" do
  # It Should return a list of all users in DB 
      get :index 
      expect(response.status).to eq(200)
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:success)
    end
  end
  describe "GET current_user" do
    it "should return the current user" do
  # It Should return a list of all users in DB 
      get :current_user 
      expect(response.status).to eq(200)
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:success)
    end
  end
end
