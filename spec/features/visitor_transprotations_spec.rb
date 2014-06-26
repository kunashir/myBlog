require 'spec_helper'

describe "integration tests" do
  let(:user) { FactoryGirl.create :user }

  describe "check rules" do
    before(:each) do
      #@user = FactoryGirl.create(:user)
      login(user, 'password')
    end

    it "should not successful to new order to non-manager" do
      # login(user, 'password')
      visit new_transportation_path
      expect(page).to have_content 'Вы не можете создавать заявки!!!'
    end
  end
end