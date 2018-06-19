class User < ApplicationRecord
  has_many :friendship_requests
  has_many :friendships
  has_many :posts
  has_many :views
  has_many :likes


  has_many :requesters, :through => :friendship_requests, :class_name => "User", :foreign_key => "friend_id", :source => "friend"
  has_many :friends, :through => :friendships, :class_name => "User", :foreign_key => "friend_id"
  has_many :viewed_posts, :through => :views, :class_name => "Post", :foreign_key => "post_id", :source => "post"
  has_many :liked_posts, :through => :views, :class_name => "Post", :foreign_key => "post_id", :source => "post"

  def friends_posts
    Post.where(author: self.friends)
  end

  def unseen_posts
    vp = viewed_posts.map { |p| p.id }
    friends_posts.where.not(id: vp)
  end

end
