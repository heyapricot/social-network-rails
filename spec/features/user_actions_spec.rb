require 'rails_helper'

RSpec.feature "UserActions", type: :feature do
  let(:user){FactoryBot.create(:user)}

  scenario "Visit user show page" do
    visit user_path(user.id)
    expect(page).to have_text(user.first_name)
  end
end
