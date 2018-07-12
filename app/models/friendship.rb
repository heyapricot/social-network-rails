class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, :class_name => "User"

  enum status: %i[requested accepted rejected]

  after_update :check_status

  def check_status
    case status
    when "accepted"
      Friendship.create(user: friend, friend: user, status: :accepted)
    end
  end
end
