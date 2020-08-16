class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[create]
  before_action :load_subscription, only: %i[destroy]

  authorize_resource

  def create
    @subscription = current_user.subscriptions.create(question: @question)
  end

  def destroy
    @question = current_user&.subscriptions.where(id: @subscription.id).take.question_id  #наверно нужен scope
    @subscription.destroy
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_subscription
    @subscription = Subscription.find(params[:id])
  end
end
