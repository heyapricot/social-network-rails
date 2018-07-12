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

    user.requesters << friends

    expect(user.requesters).to match_array(friends)

  end

  it "can get all the posts made by friends" do
    friend_quantity = 4
    post_quantity = 2

    friends = Array.new
    posts = Array.new

    friend_quantity.times {friends << FactoryBot.create(:user)}
    friends.each {|f| post_quantity.times {posts << FactoryBot.create(:post, user_id: f.id)} }

    user.friends << friends

    feed = user.friends_posts

    expect(feed.length).to eq (friend_quantity * post_quantity)
    expect(feed).to match_array(posts)

  end

  it "can get all the posts made by friends that the user haven't seen" do
    friend_quantity = 4
    post_quantity = 2

    friends = Array.new
    posts = Array.new
    unseen_posts = Array.new

    friend_quantity.times {friends << FactoryBot.create(:user)}
    friends.each do |f|
      post_quantity.times {posts << FactoryBot.create(:post, user_id: f.id)}
      f.posts.first.viewers << user
      unseen_posts << f.posts.second
    end

    user.friends << friends

    expect(unseen_posts.length).to eq (friend_quantity)
    expect(unseen_posts).to match_array(unseen_posts)

  end

  it "Can get a list of friend requests" do
    friend = FactoryBot.create(:user)
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
