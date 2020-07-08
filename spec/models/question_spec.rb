require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:author).class_name(:User) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:award).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :award }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'votable' do
    let!(:question) { create(:question) }
    let!(:user) { create(:user) }
    let!(:vote) { create(:vote, votable: question, user: user) }
    let!(:another_user) { create(:user) }

    it '#create_vote' do
      expect(question.votes_sum).to equal 1
    end

    it '#votes_sum' do
      question.create_vote(another_user, 1)

      expect(question.votes_sum).to equal 2
    end

    it '#delete_vote' do
      question.create_vote(user, -1)

      expect(question.votes_sum).to equal 0
    end
  end
end
