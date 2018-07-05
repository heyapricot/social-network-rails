class CommentsController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    comment = post.comments.new(:author => current_user, :content => params[:comment][:content])
    redirect_back(fallback_location: user_path(current_user)) if comment.save
  end
end