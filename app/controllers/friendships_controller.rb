class FriendshipsController < ApplicationController
  def index
    users = current_user.requesters
    @slices = []
    users.each_slice((users.length/2.0).ceil){|s| @slices << s} unless users.empty?
  end

  def create
    user = User.find(params[:user_id])
    fr = Friendship.create(user: current_user, friend: user, status: :requested)
    redirect_back(fallback_location: users_path) if fr.save
  end
end
