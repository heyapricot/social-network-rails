require 'rails_helper'

RSpec.feature "UserSessions", type: :feature do

  let(:user){FactoryBot.create(:user)}

  scenario "Visit /login and fill form to log in" do
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "f4k3p455w0rd"
    click_button "Log in"

    expect(page).to have_text("Hello, #{user.first_name}")
    expect(current_path).to eql(root_path)
  end
end
