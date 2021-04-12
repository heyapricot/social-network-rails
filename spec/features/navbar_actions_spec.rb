require 'rails_helper'

RSpec.feature "NavbarActions", type: :feature do

  fr_quantity = 4
  let(:user){FactoryBot.create(:user)}
  let!(:received_friend_requests){FactoryBot.create_list(:friendship, fr_quantity, friend: user, status: :requested)}

  context "When a user is logged in" do

    before(:each) { login_as(user, scope: :user) }

    scenario "Visit root page with friend requests pending" do
      visit user_path(user.id)
      expect(user.received_friend_requests.count).to eq(fr_quantity)
      expect(page).to have_text("#{fr_quantity}")
    end
  end
end
