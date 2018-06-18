class Post < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "user_id"
  has_many :likes
  has_many :views
  has_many :users_who_liked, :through => :likes , :class_name => "User", :source => "user"
  has_many :users_who_viewed, :through => :views, :class_name => "User", :source => "user"
end
