require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:author).class_name(:User) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:award).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :award }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#create_vote' do
    let!(:question) { create(:question) }
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user) }

    it 'one user vote up' do
      expect(question.votes.count).to eq 0
      question.create_vote(user, 1)

      expect(question.votes.count).to eq 1
    end

    it 'one user vote up then undo vote' do
      expect(question.votes.count).to eq 0
      question.create_vote(user, 1)
      question.create_vote(user, -1)

      expect(question.votes.count).to eq 0
    end

    it 'two users vote' do
      expect(question.votes.count).to eq 0
      question.create_vote(user, 1)
      question.create_vote(another_user, -1)

      expect(question.votes.count).to eq 2
    end
  end

  describe '#votes_sum' do
    let!(:question) { create(:question) }
    let!(:user) { create(:user) }
    let!(:vote) { create(:vote, votable: question, user: user) }

    let!(:another_question) { create(:question) }
    let!(:another_user) { create(:user) }
    let!(:another_vote_1) { create(:vote, votable: another_question, user: user) }
    let!(:another_vote_2) { create(:vote, :vote_down, votable: another_question, user: another_user) }

    it 'one user vote up' do
      expect(question.votes_sum).to eq 1
    end

    it 'two users vote' do
      expect(another_question.votes_sum).to eq 0
    end
  end
end
