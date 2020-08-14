class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[create]
  before_action :load_answer, only: %i[update destroy best]

  after_action :publish_answer, only: %i[create]

  include Voted
  include Commented

  authorize_resource

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @question = @answer.question
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def best
    @answer.best! # if current_user.author_of?(@answer.question)
    @question = @answer.question
  end

  private

  def publish_answer
    return if @answer.errors.any?

    AnswersChannel.broadcast_to(@question, id: @answer.id,
                                           body: @answer.body,
                                           files: @answer.publish_files,
                                           links: @answer.links,
                                           question_author_id: @question.author.id)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body,
                                   files: [],
                                   links_attributes: %i[name url])
  end
end
