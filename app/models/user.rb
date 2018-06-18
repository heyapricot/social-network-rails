class User < ApplicationRecord
  has_many :posts
  has_many :friendships
  has_many :friendship_requests
  has_many :friend_requests, :through => :friendship_requests, :class_name => "User", :foreign_key => "friend_id", :source => "friend"
  has_many :friends, :through => :friendships, :class_name => "User", :foreign_key => "friend_id"

  def friends_posts
    Post.where(author: self.friends)
  end

end
