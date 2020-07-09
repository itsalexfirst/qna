require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author).class_name(:User) }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#best!' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let!(:answer) { create(:answer, best: true, question: question) }
    let!(:another_answer) { create(:answer, question: question) }

    let!(:award) { create(:award) }
    let!(:question_with_award) { create(:question, award: award, author: user) }
    let!(:answer_for_awarded_question) { create(:answer, question: question_with_award) }


    it 'choose another answer as best' do
      expect(answer).to be_best

      another_answer.best!

      answer.reload
      another_answer.reload

      expect(answer).to_not be_best
      expect(another_answer).to be_best
    end

    it 'choose answer as best for awarded question' do
      expect(answer_for_awarded_question.author.awards).to be_empty
      answer_for_awarded_question.best!

      answer_for_awarded_question.reload

      expect(answer_for_awarded_question.author.awards.first).to eq question_with_award.award
    end
  end

  describe '#create_vote' do
    let!(:answer) { create(:answer) }
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user) }

    it 'one user vote up' do
      expect(answer.votes.count).to eq 0
      answer.create_vote(user, 1)

      expect(answer.votes.count).to eq 1
    end

    it 'one user vote up then undo vote' do
      expect(answer.votes.count).to eq 0
      answer.create_vote(user, 1)
      answer.create_vote(user, -1)

      expect(answer.votes.count).to eq 0
    end

    it 'two users vote' do
      expect(answer.votes.count).to eq 0
      answer.create_vote(user, 1)
      answer.create_vote(another_user, -1)

      expect(answer.votes.count).to eq 2
    end
  end

  describe '#votes_sum' do
    let!(:answer) { create(:answer) }
    let!(:user) { create(:user) }
    let!(:vote) { create(:vote, votable: answer, user: user) }

    let!(:another_answer) { create(:answer) }
    let!(:another_user) { create(:user) }
    let!(:another_vote_1) { create(:vote, votable: another_answer, user: user) }
    let!(:another_vote_2) { create(:vote, :vote_down, votable: another_answer, user: another_user) }

    it 'one user vote up' do
      expect(answer.votes_sum).to eq 1
    end


    it 'two users vote' do
      expect(another_answer.votes_sum).to eq 0
    end
  end
end
