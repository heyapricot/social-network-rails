class PostsController < ApplicationController
  def create
    @post = current_user.posts.build(post_params)
    redirect_to user_path(current_user.id),turbolinks: false if @post.save
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

end
