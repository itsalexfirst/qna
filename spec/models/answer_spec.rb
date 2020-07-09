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

  describe 'votable' do
    let!(:answer) { create(:answer) }
    let!(:user) { create(:user) }
    let!(:vote) { create(:vote, votable: answer, user: user) }
    let!(:another_user) { create(:user) }

    it '#create_vote' do
      expect(answer.votes_sum).to equal 1
    end

    it '#votes_sum' do
      answer.create_vote(another_user, 1)

      expect(answer.votes_sum).to equal 2
    end

    it '#delete_vote' do
      answer.create_vote(user, -1)

      expect(answer.votes_sum).to equal 0
    end
  end
end
