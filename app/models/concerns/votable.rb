module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def create_vote(user, value)
    vote = votes.find_by(user_id: user.id)
    if vote&.vote == -value
      delete_vote(vote)
    else
      votes.create_with(vote: value).find_or_create_by(user_id: user.id)
    end
  end

  def votes_sum
    votes.sum(:vote)
  end

  private

  def delete_vote(vote)
    votes.destroy(vote)
  end
end
