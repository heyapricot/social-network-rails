class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts
  has_many :accepted_friendships, ->{where(status: :accepted)}, class_name: "Friendship"
  has_many :sent_friend_requests, ->{where(status: :requested)}, class_name: "Friendship"
  has_many :requestees, through: :sent_friend_requests, source: :friend

  def received_friend_requests
    Friendship.where(friend_id: self.id, status: :requested)
  end

  def requesters
    User.where(id: received_friend_requests.pluck(:user_id))
  end

  def friends
    user_ids = Friendship.where("(user_id = ? OR friend_id = ?) AND status = ?", self.id, self.id, Friendship.statuses[:accepted]).pluck(:user_id, :friend_id)
    unless user_ids.empty?
      user_ids.flatten!.uniq!
      user_ids.delete(self.id)
      User.where(id: user_ids)
    end
  end

  def get_friendship(user)
    Friendship.where("(user_id = :user AND friend_id = :friend) OR (user_id = :friend AND friend_id = :user )", user: self, friend: user).take!
  end

  def friends_posts
    Post.where(author: self.friends)
  end

  def unseen_posts
    Post.where(author: self.friends) - Post.joins(:views).where(author: self.friends)
  end

  def fullname
    "#{first_name} #{last_name}"
  end

end
