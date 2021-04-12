require 'rails_helper'

RSpec.describe User, type: :model do

  post_quantity = 2
  friendship_quantity = 2
  let!(:user){FactoryBot.create(:user_with_posts, posts_count: post_quantity)}
  let!(:friendships){FactoryBot.create_list(:friendship_with_posts, friendship_quantity, user: user, status: :accepted)}
  let(:friends){friendships.map{|f| f.friend}}


  describe "friendships" do

    let!(:sent_friend_requests){FactoryBot.create_list(:friendship, friendship_quantity, user: user, status: :requested)}
    let!(:received_friend_requests){FactoryBot.create_list(:friendship, friendship_quantity, friend: user, status: :requested)}
    let(:requestees){sent_friend_requests.map{|fr| fr.friend}}
    let(:requesters){received_friend_requests.map{|fr| fr.user}}

    it "can get a list of received friend requests" do
      expect(user.received_friend_requests).to match_array(received_friend_requests)
    end

    it "can get a list of sent friend requests" do
      expect(user.sent_friend_requests).to match_array(sent_friend_requests)
    end

    it "can get a list of Users that sent a friend request" do
      expect(user.requesters).to match_array(requesters)
    end

    it "can get a list of Users to which a friend request was sent" do
      expect(user.requestees).to match_array(requestees)
    end

    it "can get a list of Users that are friends" do
      expect(user.friends).to match_array(friends)
    end

    it "can get a friendship object that shares with another user" do
      expect(user.get_friendship(friendships.first.friend)).to eq(friendships.first)
    end

    context "when accepting a friend request" do

      let(:friend_request){FactoryBot.create(:friendship, user: user, status: :requested)}

      before {friend_request.accepted!}

      it "updates user.friends with the friend that sent the request" do
        expect(user.friends).to include(friend_request.friend)
      end

      it "updates friend.friends with the user that sent the request" do
        expect(friend_request.friend.friends).to include(user)
      end

      it "removes the friend from the requesters list" do
        expect(user.requesters).not_to include(friend_request.friend)
      end

      it "removes the user from the friend's requestees list" do
        expect(friend_request.friend.requestees).not_to include(user)
      end

    end
  end

  describe "posts" do

    it "can get all the posts where user is the author" do
      expect(user.posts.length).to eq post_quantity
    end

    it "can create a post" do
      content = "Test post"
      user.posts.create(content: content)
      expect(user.posts.last.content).to eq content
    end

    it "can get a list of friend's posts" do
      posts = Post.where(author: friends).to_a
      expect(user.friends).to match_array(friends)
      expect(user.friends_posts).to match_array(posts)
    end

  end
end


