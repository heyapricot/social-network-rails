require 'rails_helper'

RSpec.feature "UserActions", type: :feature do
  post_content = "Test Post"
  let(:user){FactoryBot.create(:user)}
  let(:new_user){FactoryBot.build(:user)}
  let!(:post){FactoryBot.create(:post, author: user, content: post_content)}
  let!(:friend){FactoryBot.create(:user)}

  context "When the user is logged out" do
    scenario "Visit /signup, fill form and submit" do
      visit new_user_registration_path
      fill_in "First name", with: new_user.first_name
      fill_in "Last name", with: new_user.last_name
      fill_in "Email", with: new_user.email
      fill_in "Nickname", with: new_user.nickname
      fill_in "Password", with: new_user.password
      fill_in "Password confirmation", with: new_user.password
      click_button("Sign up")

      registered_user = User.find_by(:email => new_user.email)
      expect(registered_user.first_name).to eq(new_user.first_name)
      expect(registered_user.last_name).to eq(new_user.last_name)
      expect(registered_user.nickname).to eq(new_user.nickname)
      expect(page).to have_text("Hello, #{new_user.first_name}")
      expect(current_path).to eql(root_path)
    end

    scenario "Visit /login and fill form to log in" do
      visit login_path
      fill_in "Email", with: user.email
      fill_in "Password", with: "f4k3p455w0rd"
      click_button "Log in"

      expect(page).to have_text("Hello, #{user.first_name}")
      expect(current_path).to eql(root_path)
    end
  end

  context "When the user is logged in" do

    before(:each) { login_as(user, scope: :user) }

    scenario "User visits show page" do
      visit user_path(user)
      expect(page).to have_text(user.first_name)
      expect(page).to have_text(post.content)
    end

    scenario "User sends a friend request from index page" do
      visit users_path
      click_link "Add Friend"
      expect(friend.requesters.include?(user)).to be(true)
      expect(page).to have_text("Requested")
    end

    scenario "Create a post from the current user's show page" do
      visit user_path(user)
      fill_in "post_content", with: "Post creation test"
      click_button "Post"
      expect(page).to have_text(text)
    end

    pending "Create a comment on a post froma user page" do
      visit user_path(user)
      fill_in "comment_content", with: "Comment creation test"
      click_button "Comment"
      expect(page).to have_text(comment)
    end
  end
end