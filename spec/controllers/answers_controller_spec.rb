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

      it 'return forbidden' do
        post :update, params: { id: answer, answer: { body: 'new body'} }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question) }

    context 'author of answer' do
      before { login(answer.author) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render template destroy' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'not author of answer' do
      before { login(user) }

      it 'try to deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'return forbidden' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PATCH #best' do
    let!(:answer) { create(:answer, question: question) }

    context 'author of question' do
      before { login(question.author) }

      it 'choose best answer' do
        patch :best, params: { id: answer, answer: { best: true } }, format: :js
        answer.reload

        expect(answer.best).to eq true
      end

      it 'render template best' do
        patch :best, params: { id: answer, answer: { best: true } }, format: :js

        expect(response).to render_template :best
      end
    end

    context 'not author of question' do
      before { login(user) }

      it 'try to choose best answer' do
        patch :best, params: { id: answer, answer: { best: true } }, format: :js
        answer.reload

        expect(answer.best).to_not eq true
      end

      it 'return forbidden' do
        patch :best, params: { id: answer, answer: { best: true } }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST #vote_up' do
    let!(:answer) { create(:answer) }

    context 'author of answers' do
      before { login(answer.author) }

      it 'vote up for answer' do
        post :vote_up, params: { id: answer }, format: :js
        expect(answer.votes_sum).to eq 0
      end
    end

    context 'not author of answers' do
      before { login(user) }

      it 'vote up for answer' do
        post :vote_up, params: { id: answer }, format: :js
        expect(answer.votes_sum).to eq 1
      end
    end
  end

  describe 'POST #vote_down' do
    let!(:answer) { create(:answer) }

    context 'author of answers' do
      before { login(answer.author) }

      it 'vote down for question' do
        post :vote_down, params: { id: answer }, format: :js
        expect(answer.votes_sum).to eq 0
      end
    end

    context 'not author of answers' do
      before { login(user) }

      it 'vote down for answer' do
        post :vote_down, params: { id: answer }, format: :js
        expect(answer.votes_sum).to eq(-1)
      end
    end
  end

  describe 'POST #comment' do
    let!(:answer) { create(:answer) }

    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new comment in the database' do
        expect { post :comment, params: { comment: attributes_for(:comment), commentable: answer, id: answer.id, format: :js } }.to change(Comment, :count).by(1)
      end
      it 'assign author' do
        post :comment, params: { comment: attributes_for(:comment), id: answer.id, format: :js }
        expect(user).to be_author_of(assigns(:comment))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the comment' do
        expect { post :comment, params: { comment: attributes_for(:comment, :invalid) , commentable: answer, id: answer.id, format: :js} }.to_not change(Comment, :count)
      end
    end
  end
end
