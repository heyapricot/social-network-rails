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

  scenario "Visit /signup, fill form and submit" do
    user = FactoryBot.build(:user)

    visit new_user_registration_path
    fill_in "First name", with: user.first_name
    fill_in "Last name", with: user.last_name
    fill_in "Email", with: user.email
    fill_in "Nickname", with: user.nickname
    fill_in "Password", with: user.password
    fill_in "Password confirmation", with: user.password

    click_button("Sign up")

    expect(page).to have_text("Hello, #{user.first_name}")
    expect(current_path).to eql(root_path)
  end

end
