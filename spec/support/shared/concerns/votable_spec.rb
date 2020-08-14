require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  describe '#create_vote' do
    let!(:votable) { create(described_class.to_s.underscore.to_sym) }
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user) }

    it 'one user vote up' do
      expect(votable.votes.count).to eq 0
      votable.create_vote(user, 1)

      expect(votable.votes.count).to eq 1
    end

    it 'one user vote up then undo vote' do
      expect(votable.votes.count).to eq 0
      votable.create_vote(user, 1)
      votable.create_vote(user, -1)

      expect(votable.votes.count).to eq 0
    end

    it 'two users vote' do
      expect(votable.votes.count).to eq 0
      votable.create_vote(user, 1)
      votable.create_vote(another_user, -1)

      expect(votable.votes.count).to eq 2
    end
  end

  describe '#votes_sum' do
    let!(:votable) { create(described_class.to_s.underscore.to_sym) }
    let!(:user) { create(:user) }
    let!(:vote) { create(:vote, votable: votable, user: user) }

    let!(:another_votable) { create(described_class.to_s.underscore.to_sym) }
    let!(:another_user) { create(:user) }
    let!(:another_vote_1) { create(:vote, votable: another_votable, user: user) }
    let!(:another_vote_2) { create(:vote, :vote_down, votable: another_votable, user: another_user) }

    it 'one user vote up' do
      expect(votable.votes_sum).to eq 1
    end

    it 'two users vote' do
      expect(another_votable.votes_sum).to eq 0
    end
  end
end
