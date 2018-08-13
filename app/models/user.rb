class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook]
  has_many :posts
  has_many :accepted_friendships, ->{where(status: Friendship.statuses[:accepted])}, class_name: "Friendship"
  has_many :sent_friend_requests, ->{where(status: Friendship.statuses[:requested])}, class_name: "Friendship"
  has_many :requestees, through: :sent_friend_requests, source: :friend
  has_attached_file :avatar, styles: { medium: "100x100>", thumb: "150x150>" }, default_url: "/images/:style/missing.png"
  validates_attachment :photo, content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }, size: { in: 0..5.megabytes }

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] &&  session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.name.split(" ")[0]
      user.last_name = auth.info.name.split(" ")[1]
      #user.image = auth.info.avatar
    end
  end

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

  def timeline_posts
    self.friends.nil? ? ids = Array.new : ids = self.friends.pluck(:id)
    ids << self.id
    Post.where(user_id: ids)
  end

  def unseen_posts
    Post.where(author: self.friends) - Post.joins(:views).where(author: self.friends)
  end

  def fullname
    "#{first_name} #{last_name}"
  end

end
