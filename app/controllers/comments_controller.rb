class CommentsController < ApplicationController
  def create
    # binding.pry
    @comment = Comment.new(comment_params)
    # binding.pry
    if @comment.save
      # prototype_path(prototype.id)
      redirect_to prototype_path(@comment.prototype)
    else
      @prototype = @comment.prototype
      @comments = @prototype.comments
      render "prototypes/show" 
    end
  end

  private
  def comment_params
    # binding.pry
    params.require(:comment).permit(:text).merge(user_id: current_user.id, prototype_id: params[:prototype_id])
  end
end
