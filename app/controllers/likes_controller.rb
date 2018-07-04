class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @post.likers << current_user
    redirect_back(fallback_location: user_path(current_user))
  end
end
