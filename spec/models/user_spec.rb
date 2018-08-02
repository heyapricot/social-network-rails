require 'rails_helper'

RSpec.describe User, type: :model do

  friendship_quantity = 2
  let!(:user){FactoryBot.create(:user)}

  describe "friendships" do

    let!(:friendships){FactoryBot.create_list(:friendship, friendship_quantity, user: user, status: :accepted)}
    let!(:sent_friend_requests){FactoryBot.create_list(:friendship, friendship_quantity, user: user, status: :requested)}
    let!(:received_friend_requests){FactoryBot.create_list(:friendship, friendship_quantity, friend: user, status: :requested)}
    let(:friends){friendships.map{|f| f.friend}}
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

    let!(:friendships){FactoryBot.create_list(:friendship, friendship_quantity, friend: user, status: :accepted)}
    let(:friends){friendships.map{|f| f.user}}

    it "can create a post" do
      content = "Test post"
      user.posts.create(content: content)
      expect(user.posts.first.content).to eq content
    end

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
  end
end


