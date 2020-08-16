require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do

  let!(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'without subscription' do

      before { login(user) }

      it 'create subscription' do
        expect { post :create, params: { question_id: question, format: :js } }.to change(Subscription, :count).by(1)
      end

      it 'responses ok' do
        post :create, params: { question_id: question, format: :js }
        expect(response).to be_successful
      end
    end

    context 'with subscription' do
      before { login(question.author) }
      it 'does not create subscription' do
        expect { post :create, params: { question_id: question, format: :js } }.to_not change(Subscription, :count)
      end

      it 'render_template :create' do
        post :create, params: { question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with subscription' do

      before { login(question.author) }

      let(:subscription) { Subscription.find_by(question: question, user: question.author) }

      it 'delete subscription' do
        expect { delete :destroy, params: { id: subscription, format: :js } }.to change(Subscription, :count).by(-1)
      end

      it 'responses ok' do
        delete :destroy, params: { id: subscription }, format: :js
        expect(response).to be_successful
      end
    end
  end

end
