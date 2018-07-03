require 'rails_helper'

RSpec.feature "UserActions", type: :feature do
  let(:user){FactoryBot.create(:user)}

  scenario "Visit user show page" do
    visit user_path(user.id)
    expect(page).to have_text(user.first_name)
  end

  pending "Create a post from the current user's show page" do
    test_text = "This is a test"
    visit user_path(user.id)
    fill_in "post_content", with: test_text
    click_button "Post"
    save_and_open_page
    expect(page).to have_text(test_text)
  end

end
