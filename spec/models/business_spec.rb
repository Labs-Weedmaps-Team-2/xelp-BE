require 'rails_helper'

RSpec.describe Business, type: :model do
	let(:business){Business.new()}

  describe 'business attributes' do
    it 'has expected attributes' do
      expect(business.attribute_names.map(&:to_sym)).to contain_exactly(
				:address, 
				:category, 
				:city, 
				:created_at, 
				:hours, :id, 
				:latitude, 
				:longitude, 
				:name, 
				:phone, 
				:photo, 
				:price, 
				:rating, 
				:state, 
				:status, 
				:updated_at, 
				:yelp_id, 
				:zipcode
      )
    end
  end
  describe 'business model associations' do
		it { should have_many(:reviews) }
	end
end
