require 'rails_helper'
FRIENDSHIPS = 3
COMMENTS = 3
POSTS = 3
RSpec.feature 'PostActions', type: :feature do
  let!(:user) { FactoryBot.create(:user_with_posts) }
  let!(:friendships) do
    FactoryBot.create_list(
      :friendship_with_posts,
      FRIENDSHIPS,
      user: user,
      status: :accepted
    )
  end
  let(:post) { FactoryBot.create(:post, author: user) }

  context 'When a User has friends' do
    let!(:user) { FactoryBot.create(:user_with_friends) }
    let(:friends) { user.friends }

    context "When the User's friend's have posts" do
      let!(:friends_posts) do
        friends.each { |author|FactoryBot.create(:post, author: author) }
      end

      context 'When the logged user has posts' do
        let!(:user_posts) { FactoryBot.create(:post, author: user) }

        describe 'Visit the post index page' do
          before(:each) do
            login_as(user, scope: :user)
            visit posts_path
          end

          describe "display posts by the logged user's friends" do
            let(:friends_posts) { Post.where(author: user.friends) }

            it 'displays the author' do
              friends_posts.each do |post|
                expect(page).to have_text post.author.fullname
              end
            end

            it 'displays the content' do
              friends_posts.each do |post|
                expect(page).to have_text post.author.fullname
              end
            end
          end

          describe 'display posts by the logged user' do
            let(:logged_user_posts) { user.posts }

            it 'displays the author' do
              logged_user_posts.each do |post|
                expect(page).to have_text post.author.fullname
              end
            end

            it 'displays the content' do
              logged_user_posts.each do |post|
                expect(page).to have_text post.author.fullname
              end
            end
          end
        end
      end
    end
  end

  context 'With a user logged in' do
    before(:each) do
      login_as(user, scope: :user)
      visit posts_path
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
          COMMENTS,
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
