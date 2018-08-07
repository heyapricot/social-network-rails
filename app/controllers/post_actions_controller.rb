class PostActionsController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    post_action = PostAction.new(post: post)

    case params[:post_action]
    when "comment"
      post_action = post.comments.new(user: current_user, content: params[:content])
    when "like"
      post_action = post.likes.new(user: current_user)
    end

    redirect_back(fallback_location: user_path(current_user)) if post_action.save!
  end

end
