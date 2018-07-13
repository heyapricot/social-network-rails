require 'rails_helper'

RSpec.describe Post, type: :model do

  let(:users){FactoryBot.create_list(:user, 2)}
  let(:post){FactoryBot.create(:post, author: user)}

  context "when liking a post" do
    let(:users) {FactoryBot.create_list(:user, 4)}
    let(:post){FactoryBot.create(:post, author: users.first)}

    it "keeps track of the number of likes" do
      users.each { |u| post.likes.create(user: u) }
      expect(post.likes.size).to eq users.length
    end

    it "can get a list of Users who liked the post" do
      users.each { |u| post.likes.create(user: u) }
      expect(post.likers).to match_array(users)
    end
  end

  context "when viewing a post" do
    let(:users) {FactoryBot.create_list(:user, 4)}
    let(:post){FactoryBot.create(:post, author: users.first)}

    it "keeps track of the number of views" do
      users.each { |u| post.viewers << u }
      expect(post.views.size).to eq users.length
    end

    it "can get a list of Users who viewed the post" do
      users.each { |u| post.viewers << u }
      expect(post.viewers).to match_array(users)
    end
  end

  context "when commenting a post" do
    let(:users) {FactoryBot.create_list(:user, 4)}
    let(:post){FactoryBot.create(:post, author: users.first)}
    content = "Test comment"
    before {users.each { |u| post.comments.create(user: u, content: content) }}

    it "keeps track of the number of comments" do
      post.comments.each do |c|
        expect(c.content).to eq content
        expect(users.include? c.user).to be true
      end
    end

    it "can get a list of Users who commented the post" do
      expect(post.commenters).to match_array(users)
    end
  end

end
