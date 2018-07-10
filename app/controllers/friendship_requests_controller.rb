class FriendshipRequestsController < ApplicationController
  def create
    user = User.find(params[:user_id])
    fr = user.friendship_requests.new(friend: current_user)
    redirect_back(fallback_location: users_path) if fr.save
  end
end