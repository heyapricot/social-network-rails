class User < ApplicationRecord
  has_many :posts
  has_many :friendships
  has_many :friends, :through => :friendships, :class_name => "User", :foreign_key => "friend_id"
end
