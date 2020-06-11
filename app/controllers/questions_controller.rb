class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.links.build
  end

  def new
    @question = Question.new
    @question.links.build
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    else
      redirect_to @question, notice: 'Your cant deleted question.'
    end
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [],
                                     links_attributes: [:name, :url])
  end
end
