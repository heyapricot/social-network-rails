class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
  end

  def index
    users = User.where.not(id: current_user.id)
    @slices = []
    users.each_slice((users.length/2.0).ceil){|s| @slices << s}
  end
end
