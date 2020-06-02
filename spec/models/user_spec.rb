require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'method .author_of?' do
    let!(:author) { create(:user) }
    let!(:user) { create(:user) }

    let!(:authors_question) { create(:question, author: author) }
    let!(:authors_answer) { create(:answer, question: authors_question, author: author) }

    let!(:users_question) { create(:question, author: user) }
    let!(:users_answer) { create(:answer, question: users_question, author: user) }

    it 'author of own question' do
      expect(author).to be_author_of(authors_question)
    end

    it 'author of own answer' do
      expect(author).to be_author_of(authors_answer)
    end

    it 'user is not author of question' do
      expect(author).to_not be_author_of(users_question)
    end

    it 'user is not author of answer' do
      expect(author).to_not be_author_of(users_answer)
    end
  end
end
