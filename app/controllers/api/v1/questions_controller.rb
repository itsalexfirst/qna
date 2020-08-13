class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: %i[show edit update destroy]

  authorize_resource class: Question

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
