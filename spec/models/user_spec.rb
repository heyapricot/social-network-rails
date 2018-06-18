require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user){FactoryBot.create(:user)}

  it "has many posts" do

    post_quantity = 3

    post_quantity.times {FactoryBot.create(:post, author: user)}
    expect(user.posts.length).to eq(post_quantity)
  end

  it "can receive and store users as friend requests" do
    friends = Array.new
    friend_request_num = 3

    friend_request_num.times {friends << FactoryBot.create(:user)}

    user.friend_requests << friends

    expect(user.friend_requests).to match_array(friends)

  end

  context "when accepting a friend request" do

    user = FactoryBot.create(:user)
    friend = FactoryBot.create(:user)

    before(:all) do
      user.friend_requests << friend
      user.friendship_requests.find_by(friend_id: friend.id).accept
    end

    it "updates user.friends with the friend that sent the request" do
      expect(user.friends).to include(friend)
    end

    it "updates friend.friends with the friend that sent the request" do
      expect(friend.friends).to include(user)
    end

    it "deletes the request" do
      expect(user.friendship_requests.find_by(friend_id: friend.id).nil?).to be true
    end

  end
end
