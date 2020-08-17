require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:awards) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribed_questions).through(:subscriptions).source(:question) }

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

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('FindForAuthService') }

    it 'calls FindForAuthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
