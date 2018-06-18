class FriendshipRequest < ApplicationRecord
  belongs_to :user
  belongs_to :friend, :class_name => "User"

  def accept
    user.friends << friend
    friend.friends << user
    destroy
  end

end
