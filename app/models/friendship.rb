class Friendship < ApplicationRecord
  enum status: %i[requested accepted rejected]
  belongs_to :user
  belongs_to :friend,class_name: "User"
end
