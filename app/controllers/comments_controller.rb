class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.post = Post.find(params[:post_id])

    if @comment.save
      redirect_to @comment.post, notice: 'Comment was successfully created'
    else
      render "post/show"
    end
  end

  def comment_params
    params.require(:comment).permit(
      :body,
      :author_name,
    )
  end
end
