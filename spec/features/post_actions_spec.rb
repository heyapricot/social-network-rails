require 'rails_helper'

RSpec.feature "PostActions", type: :feature do

  friendship_quantity = 4
  let!(:user){FactoryBot.create(:user_with_posts)}
  let!(:friendships){FactoryBot.create_list(:friendship_with_posts, friendship_quantity, user: user, status: :accepted)}

  context "With a user logged in" do
    before(:each) { login_as(user, scope: :user) }

    scenario "Visit post index page" do
      visit posts_path
      friendships.each do |friendship|
        friendship.friend.posts.each do |p|
          expect(page).to have_text p.author.fullname
          expect(page).to have_text p.content
        end
      end
      user.posts.each{|p| expect(page).to have_text(p.content)}
    end

  end

end
