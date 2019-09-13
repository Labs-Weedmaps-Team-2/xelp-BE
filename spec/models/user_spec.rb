require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user){User.new()}

  describe 'user attributes' do
    it 'has expected attributes' do
      expect(user.attribute_names.map(&:to_sym)).to contain_exactly(
        :created_at, 
        :email, 
        :id, 
        :photo, 
        :provider, 
        :uid, 
        :updated_at, 
        :username
      )
    end
  end
  describe 'user associations' do
		it { should have_many(:reviews) }
	end
end
