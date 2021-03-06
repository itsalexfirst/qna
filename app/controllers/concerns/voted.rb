module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: %i[vote_up vote_down]
  end

  def vote_up
    authorize! :vote_up, @votable

    process_vote(@votable, 1)
  end

  def vote_down
    authorize! :vote_down, @votable

    process_vote(@votable, -1)
  end

  private

  def process_vote(votable, value)
    votable.create_vote(current_user, value)
    render json: { res_name: votable.class.name.downcase, id: votable.id, votes_sum: votable.votes_sum }
  end

  def model_klass
    controller_name.classify.constantize
  end

  def load_votable
    @votable = model_klass.find(params[:id])
  end
end
