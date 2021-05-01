require 'rails_helper'
FRIEND_REQUEST_QUANTITY = 4
RSpec.feature 'NavbarActions', type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let!(:received_friend_requests) do
    FactoryBot.create_list(
      :friendship,
      FRIEND_REQUEST_QUANTITY,
      friend: user,
      status: :requested
    )
  end

  context 'When a user is logged in' do
    before(:each) { login_as(user, scope: :user) }

    scenario 'Visit root page with friend requests pending' do
      visit user_path(user.id)
      expect(user.received_friend_requests.count).to eq(FRIEND_REQUEST_QUANTITY)
      expect(page).to have_text("#{FRIEND_REQUEST_QUANTITY}")
    end
  end
end
