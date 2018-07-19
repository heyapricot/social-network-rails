class User < ApplicationRecord
  has_many :posts
  has_many :friendships, ->{where(status: :accepted)}, class_name: :Friendship
  has_many :friend_requests, ->{where(status: :requested)}, class_name: :Friendship
  has_many :requesters, through: :friend_requests, source: :friend

  def friends
    User.joins("INNER JOIN friendships ON users.id = friendships.friend_id").where("friendships.user_id = ?", self.id)  +  User.joins("INNER JOIN friendships ON users.id = friendships.user_id").where("friendships.friend_id = ?", self.id)
  end

  def friends_posts
    Post.where(author: self.friends)
  end

  def unseen_posts
    Post.where(author: self.friends) - Post.joins(:views).where(author: self.friends)
  end

end
