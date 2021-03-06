require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }

    let(:user_question) { create(:question, :with_file, author: user) }
    let(:not_user_question) { create(:question, :with_file) }
    let(:user_answer) { create(:answer, :with_file, author: user) }
    let(:not_user_answer) { create(:answer, :with_file) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }

    it { should be_able_to :update, create(:question, author: user) }
    it { should_not be_able_to :update, create(:question, author: other_user) }

    it { should be_able_to :update, create(:answer, author: user) }
    it { should_not be_able_to :update, create(:answer, author: other_user) }

    it { should be_able_to :destroy, create(:question, author: user) }
    it { should_not be_able_to :destroy, create(:question, author: other_user) }

    it { should be_able_to :destroy, create(:answer, author: user) }
    it { should_not be_able_to :destroy, create(:answer, author: other_user) }

    it { should be_able_to :comment, create(:question, author: user) }

    it { should be_able_to :comment, create(:answer, author: user) }

    it { should be_able_to :best, create(:answer, question: create(:question, author: user)) }
    it { should_not be_able_to :best, create(:answer, question: create(:question, author: other_user)) }

    it { should be_able_to :vote_up, create(:question, author: other_user) }
    it { should_not be_able_to :vote_up, create(:question, author: user) }

    it { should be_able_to :vote_up, create(:answer, author: other_user) }
    it { should_not be_able_to :vote_up, create(:answer, author: user) }

    it { should be_able_to :vote_down, create(:question, author: other_user) }
    it { should_not be_able_to :vote_down, create(:question, author: user) }

    it { should be_able_to :vote_down, create(:answer, author: other_user) }
    it { should_not be_able_to :vote_down, create(:answer, author: user) }

    it { should be_able_to :destroy, user_question.files.first }
    it { should_not be_able_to :destroy, not_user_question.files.first }

    it { should be_able_to :destroy, user_answer.files.first }
    it { should_not be_able_to :destroy, not_user_answer.files.first }

    it { should be_able_to :index, Award }

    it { should be_able_to :destroy, create(:link, linkable: create(:question, author: user)) }
    it { should_not be_able_to :destroy, create(:link, linkable: create(:question, author: other_user)) }
  end
end
