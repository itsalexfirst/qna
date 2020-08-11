module Commented
  extend ActiveSupport::Concern

  included do
    before_action :load_commentable, only: %i[comment]

    after_action :publish_comment, only: %i[comment]

    def comment
      authorize! :comment, @commentable

      @comment = @commentable.comments.new(comment_params)
      @comment.author = current_user
      @comment.save
    end

    private

    def publish_comment
      return if @comment.errors.any?

      question = @commentable.is_a?(Question) ? @commentable : @commentable.question

      CommentsChannel.broadcast_to(question, @comment)
    end

    def comment_params
      params.require(:comment).permit(:body)
    end

    def model_klass
      controller_name.classify.constantize
    end

    def load_commentable
      @commentable = model_klass.find(params[:id])
    end
  end
end
