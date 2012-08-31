class CommentsController < ApplicationController
  def show
    @post = Post.find_by(id: params[:id])
  end
  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    @comment.save
  end
end
