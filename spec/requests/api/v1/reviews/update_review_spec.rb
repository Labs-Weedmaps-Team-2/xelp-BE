require 'rails_helper'

RSpec.describe 'Update Review' type: :request do
  describe 'Update /api/v1/business/:id/review/:id' do
    it 'updates a review on a business' do
      put '/api/v1/business/:id/review/:id'
    end
  end
end