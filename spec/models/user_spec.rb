require 'rails_helper'

RSpec.describe User, type: :model do

  friend_quantity = 4

  let(:user){FactoryBot.create(:user)}
  let(:friends){FactoryBot.create_list(:user,4)}
    ar = Array.new
    friend_quantity.times { ar << FactoryBot.create(:user) }
    ar
  end

  describe "friendships" do
    it "can get a list of Users that are friends" do
      user.friendships.create(friend: friends.first, status: :accepted)
      friends[1..-1].each {|f| f.friendships.create(friend: user, status: :accepted)}
      expect(user.friends).to match_array(friends)
    end

    it "can get a list of friend requests and the requesters" do
      friend = friends.first
      user.requesters << friend
      expect(user.friend_requests.where(friend: friend).length).to be 1
      expect(user.friend_requests.where(friend: friend).first.friend).to eq friend
    end

    context "when accepting a friend request" do

      let(:user){FactoryBot.create(:user)}
      let(:friend){FactoryBot.create(:user)}

      before do
        user.requesters << friend
        user.friend_requests.where(friend: friend).first.accepted!
      end

      it "updates user.friends with the friend that sent the request" do
        expect(user.friends).to include(friend)
      end
      it "updates friend.friends with the friend that sent the request" do
        expect(friend.friends).to include(user)
      end

      it "deletes the request" do
        expect(user.friend_requests.where(friend: friend).empty?).to be true
      end

    end
  end

  describe "posts" do
    before {friends.each{|f| f.friendships.create(friend: user, status: :accepted)}}
    it "can create a post" do
      content = "Test post"
      user.posts.create(content: content)
      expect(user.posts.first.content).to eq content
    it "can get a list of friend's posts" do
      posts = []
      content = "Test post"
      friends.each {|f| 2.times{posts << f.posts.create(content: content)}}
      expect(user.friends).to match_array(friends)
      expect(user.friends_posts).to match_array(posts)
    end

    it "can get a list of friend's unseen posts" do
      unseen_posts = []
      content = "Test post"
      friends.each {|f| 2.times{ f.posts.create(content: content)}}
      friends.each {|f| f.posts.first.viewers << user}
      friends.each {|f| unseen_posts << f.posts.second }
      expect(user.unseen_posts).to match_array(unseen_posts)
    end

      friend = friends.first
      user.requesters << friend
      user.friendship_requests.find_by(friend_id: friend.id).accept
  end

end
