class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: %i[index create]
  before_action :load_answer, only: %i[show]

  authorize_resource

  def index
    render json: @question.answers, each_serializer: AnswersSerializer
  end

  def show
    render json: @answer
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.author = current_resource_owner

    if @answer.save
      render json: @answer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
