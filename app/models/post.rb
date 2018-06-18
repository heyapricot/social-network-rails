class Post < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "user_id"
  has_many :likes
  has_many :users_who_liked, :through => :likes , :class_name => "User", :source => "user"
end
