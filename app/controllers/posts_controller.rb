class PostsController < ApplicationController

  def index

  end

  def create
    post = current_user.posts.new(:content => params[:post][:content])
    redirect_back(fallback_location: user_path(current_user)) if post.save
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

end
