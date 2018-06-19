class Post < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "user_id"
  has_many :likes
  has_many :views
  has_many :viewers, :through => :views, :class_name => "User", :foreign_key => "user_id", :source => "user"
  has_many :likers, :through => :likes, :class_name => "User", :foreign_key => "user_id", :source => "user"
end
