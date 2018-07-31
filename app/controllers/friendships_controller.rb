class FriendshipsController < ApplicationController
  def index
    users = current_user.requesters
    @slices = []
    users.each_slice((users.length/2.0).ceil){|s| @slices << s} unless users.empty?
  end

  def create
    user = User.find(params[:user_id])
    fr = user.friend_requests.new(friend: current_user)
    redirect_back(fallback_location: users_path) if fr.save
  end
end
