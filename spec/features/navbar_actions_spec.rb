require 'rails_helper'

RSpec.feature "NavbarActions", type: :feature do

  friend_quantity = 4
  let(:user){FactoryBot.create(:user)}
  let(:friends){FactoryBot.create_list(:user,friend_quantity)}

  context "When a user is logged in" do

    before(:each) { login_as(user, scope: :user) }

    scenario "Visit root page with friend requests pending" do
      friends.each {|f| user.requesters << f}
      visit user_path(user.id)
      expect(user.friend_requests.count).to eq(friend_quantity)
      expect(page).to have_text("#{friend_quantity}")
    end
  end
end
