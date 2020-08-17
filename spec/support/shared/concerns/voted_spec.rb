require 'rails_helper'

shared_examples_for 'voted' do

  let(:user) { create(:user) }
  let(:votable) { create(described_class.controller_name.classify.underscore.to_sym) }

  describe 'POST #vote_up' do

    context 'author of votable' do
      before { login(votable.author) }

      it 'vote up for votable' do
        post :vote_up, params: { id: votable }, format: :js
        expect(votable.votes_sum).to eq 0
      end
    end

    context 'not author of votable' do
      before { login(user) }

      it 'vote up for answer' do
        post :vote_up, params: { id: votable }, format: :js
        expect(votable.votes_sum).to eq 1
      end
    end
  end

  describe 'POST #vote_down' do
    let(:votable) { create(described_class.controller_name.classify.underscore.to_sym) }

    context 'author of votables' do
      before { login(votable.author) }

      it 'vote down for question' do
        post :vote_down, params: { id: votable }, format: :js
        expect(votable.votes_sum).to eq 0
      end
    end

    context 'not author of votables' do
      before { login(user) }

      it 'vote down for votable' do
        post :vote_down, params: { id: votable }, format: :js
        expect(votable.votes_sum).to eq(-1)
      end
    end
  end
end
