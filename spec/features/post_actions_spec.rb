require 'rails_helper'

RSpec.feature 'PostActions', type: :feature do
  friendship_quantity = 4
  comment_quantity = 2

  let!(:user) { FactoryBot.create(:user_with_posts) }
  let!(:friendships) do
    FactoryBot.create_list(
      :friendship_with_posts,
      friendship_quantity,
      user: user,
      status: :accepted
    )
  end
  let(:post) { FactoryBot.create(:post, author: user) }

  context 'With a user logged in' do
    before(:each) { login_as(user, scope: :user) }

    scenario 'Visit post index page' do
      visit posts_path
      friendships.each do |friendship|
        friendship
          .friend
          .posts
          .each do |p|
            expect(page).to have_text p.author.fullname
            expect(page).to have_text p.content
          end
      end
      user.posts.each { |p| expect(page).to have_text(p.content) }
    end

    scenario 'Create a comment on a post froma user page' do
      comment = 'Comment creation test'
      visit post_path(post)
      fill_in 'content', with: comment
      click_button 'Comment'
      expect(page).to have_text(comment)
    end

    context 'When a post has likes and comments' do
      let!(:post) { FactoryBot.create(:post_with_likes, author: user) }
      let!(:comments) do
        FactoryBot.create_list(
          :post_action,
          comment_quantity,
          post: post,
          user: user,
          action: :comment,
          content: Faker::Games::Overwatch.quote
        )
      end
      scenario 'visit post show page' do
        visit post_path(post)
        comments.each { |c| expect(page).to have_text(c.content) }
        post.likers.each { |l| expect(page).to have_text(l.fullname) }
      end
    end

    scenario 'Like a post' do
      visit post_path(post)
      click_link 'Like'
      section = find_by_id('likes')
      expect(section).to have_text(user.fullname)
    end

    scenario 'Comment a post, then like' do
      comment = 'Comment creation test'
      visit post_path(post)
      fill_in 'content', with: comment
      click_button 'Comment'
      click_link 'Like'
      expect(page).to have_text(comment)
    end
  end
end
