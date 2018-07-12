class Post < ApplicationRecord
  belongs_to :author, class_name: :User, foreign_key: :user_id
  has_many :likes, ->{where(action: :like)}, class_name: :PostAction
  has_many :views, ->{where(action: :view)}, class_name: :PostAction
  has_many :comments, ->{where(action: :comment)}, class_name: :PostAction
  has_many :likers, through: :likes, source: :user
  has_many :viewers, through: :views, source: :user
  has_many :commenters, through: :comments, source: :user
end
