require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:awards) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let!(:author) { create(:user) }

    let!(:authors_question) { create(:question, author: author) }
    let!(:users_question) { create(:question) }

    it 'user is author of own question' do
      expect(author).to be_author_of(authors_question)
    end

    it 'user is not author of question' do
      expect(author).to_not be_author_of(users_question)
    end
  end
end
