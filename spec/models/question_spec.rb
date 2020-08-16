require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:author).class_name(:User) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:award).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribed_users).through(:subscriptions).source(:user) }


  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :award }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'votable'

  describe 'reputatation' do
    let(:question) { build(:question) }

    it 'call ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end

  end
end
