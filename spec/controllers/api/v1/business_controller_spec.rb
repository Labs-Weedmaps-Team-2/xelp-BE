require 'rails_helper'

RSpec.describe Api::V1::BusinessController, type: :controller do
  describe 'business params restrictions' do
    it do
      params = {
        business: {
          id: 1, name: 'Walmart', address:'124 Fake St.', city: 'Hollywood', state: 'CA', zipcode: 90210, photo: 'photo', phone: '123-234-5436', hours:'none', category:'store', photos: []
        }
      }
      should permit(:id, :name, :address, :city, :state, :zipcode, :photo, :phone, :hours, :category, :website, :photos=>[]).
        for(:create, params: params).
        on(:business)
    end
  end
end
