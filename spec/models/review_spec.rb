require 'rails_helper'

RSpec.describe Review, type :model do
  let(:new_review){Review.new()}

  describe 'review attributes' do
    it 'has expected attributes' do
      expect(new_review.attribute_names.map(&:to_sym)).to contain_exactly(
        :id,
        :text,
        :rating,
        :user,
        :avatar,
        :business,
        :created_at,
        :updated_at,
        :uid
      )
    end
  end
end