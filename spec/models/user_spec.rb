require "rails_helper"

RSpec.describe User, type: :model do
  describe "sanity check" do
    it { expect(2+2).to eq 4 }
  end
  let(:new_user){User.new()}
  describe "user attributes" do
    it "has expected attributes" do
      expect(new_user.attribute_names.map(&:to_sym)).to contain_exactly(
        :id,
        :username,
        :email,
        :photo,
        :updated_at,
        :created_at,
        :provider,
        :uid
      )
    end
  end
end