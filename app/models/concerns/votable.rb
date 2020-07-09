module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def create_vote(user, value)
    vote = votes.find_by(user: user)
    if vote&.vote == -value
      vote.destroy
    else
      votes.find_or_create_by(user: user, vote: value)
    end
  end

  def votes_sum
    votes.sum(:vote)
  end
end
