require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end

      it 'assign author' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(user).to be_author_of(assigns(:answer))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATH #update' do
    let!(:answer) { create(:answer, question: question) }

    context 'author of answer with valid attributes' do
      before { login(answer.author) }

      it 'changes answer attributes' do
        post :update, params: { id: answer, answer: { body: 'edit text' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'edit text'
      end

      it 'render update template' do
        post :update, params: { id: answer, answer: { body: 'edit text' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'author of answer with with invalid attributes' do
      before { login(answer.author) }

      it 'does not save the answer' do
        expect do
          post :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'render update template' do
        post :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'not author of answer' do
      before { login(user) }

      it 'try to edit the answer' do
        post :update, params: { id: answer, answer: { body: 'new body'} }, format: :js
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end

      it 'render update template' do
        post :update, params: { id: answer, answer: { body: 'new body'} }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question) }

    context 'author of answer' do
      before { login(answer.author) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end

    context 'not author of answer' do
      before { login(user) }

      it 'try to deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(0)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end
  end
end
