require 'rails_helper'

RSpec.feature "UserActions", type: :feature do
  let(:user){FactoryBot.create(:user)}

  before(:each) { login_as(user, :scope => :user) }

  scenario "Visit user show page" do

    post = user.posts.create(content: "Test Post")

    visit user_path(user.id)

    expect(page).to have_text(user.first_name)
    expect(page).to have_text(post.content)
  end

  scenario "Create a comment on a post froma user page" do
    post = user.posts.create(content: "Test Post")
    comment = "This is a comment"
    visit user_path(user.id)
    fill_in "comment_content", with: comment
    click_button "Comment"
    expect(page).to have_text(comment)
  end

  pending "Create a post from the current user's show page" do
    text = "This is a test"
    visit user_path(user.id)
    fill_in "post_content", with: text
    click_button "Post"
    #save_and_open_page
    expect(page).to have_text(text)
  end

end
