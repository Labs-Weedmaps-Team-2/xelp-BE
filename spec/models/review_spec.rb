require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:new_review){Review.new()}

  describe 'review attributes' do
    it 'has expected attributes' do
      expect(new_review.attribute_names.map(&:to_sym)).to contain_exactly(
        :business_id,
        :id,
        :rating,
        :text,
        :user_id,
        :created_at, 
        :updated_at
      )
    end
  end
  describe 'review model associations' do
		it { should belong_to(:user) }
		it { should belong_to(:business) }
	end
end