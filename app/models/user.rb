class User < ApplicationRecord
  has_many :posts
  has_many :friendships, ->{where(status: :accepted)}, class_name: :Friendship
  has_many :friend_requests, ->{where(status: :requested)}, class_name: :Friendship

  has_many :requesters, through: :friend_requests, source: :friend
  has_many :friends, through: :friendships, source: :friend

  def friends_posts
    Post.where(author: self.friends)
  end

  def unseen_posts
    vp = viewed_posts.map { |p| p.id }
    friends_posts.where.not(id: vp)
  end

end
