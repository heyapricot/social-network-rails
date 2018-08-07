require 'rails_helper'

RSpec.feature "PostActions", type: :feature do

  friendship_quantity = 4
  comment_quantity = 2

  let!(:user){FactoryBot.create(:user_with_posts)}
  let!(:friendships){FactoryBot.create_list(:friendship_with_posts, friendship_quantity, user: user, status: :accepted)}
  let!(:post){FactoryBot.create(:post_with_likes, author: user)}
  let!(:comments){FactoryBot.create_list(:post_action, comment_quantity, post: post, user: user, action: :comment, content: Faker::Overwatch.quote)}

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

    scenario "visit post show page" do
      visit post_path(post)
      comments.each{|c| expect(page).to have_text(c.content)}
      post.likers.each{|l| expect(page).to have_text(l.fullname)}
    end

  end

end
