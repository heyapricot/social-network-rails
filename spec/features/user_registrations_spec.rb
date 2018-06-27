require 'rails_helper'

RSpec.feature "UserRegistrations", type: :feature do

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

    registered_user = User.find_by(:email => user.email)
    expect(registered_user.first_name).to eq(user.first_name)
    expect(registered_user.last_name).to eq(user.last_name)
    expect(registered_user.nickname).to eq(user.nickname)
    expect(page).to have_text("Hello, #{user.first_name}")
    expect(current_path).to eql(root_path)
  end
end
