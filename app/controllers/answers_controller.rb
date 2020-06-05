class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :load_question, only: %i[create]
  before_action :load_answer, only: %i[destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to @answer.question, notice: 'Your answer successfully deleted.'
    else
      redirect_to @answer.question, notice: 'Your cant deleted answer.'
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
