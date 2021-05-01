require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:users) { FactoryBot.create_list(:user, 2) }
  let(:post) { FactoryBot.create(:post, author: user) }

  context 'when liking a post' do
    let(:users) { FactoryBot.create_list(:user, 4) }
    let(:post) { FactoryBot.create(:post, author: users.first) }

    it 'keeps track of the number of likes' do
      users.each { |u| post.likes.create(user: u) }
      expect(post.likes.size).to eq users.length
    end

    it 'can get a list of Users who liked the post' do
      users.each { |u| post.likes.create(user: u) }
      expect(post.likers).to match_array(users)
    end
  end

  context 'when viewing a post' do
    let(:users) { FactoryBot.create_list(:user, 4) }
    let(:post) { FactoryBot.create(:post, author: users.first) }

    it 'keeps track of the number of views' do
      users.each { |u| post.views.create(user: u) }
      expect(post.views.size).to eq users.length
    end

    it 'can get a list of Users who viewed the post' do
      users.each { |u| post.views.create(user: u) }
      expect(post.viewers).to match_array(users)
    end
  end

  context 'post comments' do
    let(:users) { FactoryBot.create_list(:user, 4) }
    let(:post) { FactoryBot.create(:post, author: users.first) }
    content = 'Test comment'
    before do
      users.each { |u| post.comments.create(user: u, content: content) }
    end

    it 'stores the comment content and the user that created it' do
      post.comments.each do |c|
        expect(c.content).to eq content
        expect(users.include? c.user).to be true
      end
    end

    it 'can get a list of Users who commented the post' do
      expect(post.commenters).to match_array(users)
    end

    describe 'validations' do
      it 'rejects comments with empty content' do
        comment =
          post.comments.build(user: users.first, content: '            ')
        comment.valid?
        expect(comment.errors).to include(:content)
      end

      it 'rejects likes with content' do
        like =
          post.likes.build(user: users.first, content: "This shouldn't be here")
        like.valid?
        expect(like.errors).to include(:content)
      end

      it 'rejects views with content' do
        view =
          post.views.build(user: users.first, content: "This shouldn't be here")
        view.valid?
        expect(view.errors).to include(:content)
      end
    end
  end
end
