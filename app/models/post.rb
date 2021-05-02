class Post < ApplicationRecord
  belongs_to :author, class_name: :User, foreign_key: :user_id
  has_many :likes, ->{where(action: :like)}, class_name: :PostAction
  has_many :views, ->{where(action: :view)}, class_name: :PostAction
  has_many :comments, ->{where(action: :comment)}, class_name: :PostAction
  has_many :likers, through: :likes, source: :user
  has_many :viewers, through: :views, source: :user
  has_many :commenters, through: :comments, source: :user

  def display_likers(names = likers_names)
    count = names.count

    case
    when count > 3
      "#{names.first}, #{names.second} and #{count - 2} others"
    when count == 3
      "#{names.first}, #{names.second} and #{names.third}"
    when count == 2
      "#{names.first} and #{names.second}"
    when count == 1
      names.take
    end
  end

  def likers_names
    likers.map(&:fullname)
  end
end
