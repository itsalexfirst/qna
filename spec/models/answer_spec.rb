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
    let(:user) {create(:user)}
    let!(:question) { create(:question, author: user) }
    let!(:answer) { create(:answer, best: true, question: question) }
    let!(:another_answer) { create(:answer, question: question) }

    it 'choose another answer as best' do
      expect(answer).to be_best

      another_answer.best!

      answer.reload
      another_answer.reload

      expect(answer).to_not be_best
      expect(another_answer).to be_best
    end
  end
end
