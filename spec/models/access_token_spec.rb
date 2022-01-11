require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  describe "#validations" do
    it "should have valid factory" do
      access_token = build :access_token
      expect(user).to be_valid
    end
    
    it "should validate token" do
      access_token = build :access_token, token: nil, user: nil
      expect(user).not_to be_valid
      expect(user.errors.messages[:token]).to include("can't be blank")
      expect(user.errors.messages[:user]).to include("can't be blank")
    end
  end

  describe "#new" do
    it "should have a token present after initialization" do
      expect(AccessToken.new.token).to be_present
    end

    it "should generate unique token" do
      user = create :user
      expect { user.create_access_token }.to change{ AccessToken.count }.by(1)
      expect(user.build_access_token).to be_valid
    end
  end
end
