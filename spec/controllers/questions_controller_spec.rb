require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question, author: user) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new link for answer of question' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :show, params: { id: question } }

    before { get :new }
    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Question.link to @question.link' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns a new Award to @question' do
      expect(assigns(:question).award).to be_a_new(Award)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
      it 'assign author' do
        post :create, params: { question: attributes_for(:question) }
        expect(user).to be_author_of(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end
      it 're-render new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATH #update' do
    let!(:question) { create(:question) }

    context 'author of question with valid attributes' do
      before { login(question.author) }

      it 'changes question attributes' do
        post :update, params: { id: question, question: { body: 'edit text' } }, format: :js
        question.reload
        expect(question.body).to eq 'edit text'
      end

      it 'render update template' do
        post :update, params: { id: question, question: { body: 'edit text' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'author of question with with invalid attributes' do
      before { login(question.author) }

      it 'does not save the question' do
        expect do
          post :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        end.to_not change(question, :body)
      end

      it 'render update template' do
        post :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'not author of question' do
      before { login(user) }

      it 'try to edit the question' do
        post :update, params: { id: question, question: { body: 'new body' } }, format: :js
        question.reload
        expect(question.body).to_not eq 'new body'
      end

      it 'return forbidden' do
        post :update, params: { id: question, question: { body: 'new body' } }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }

    context 'author of questions' do
      before { login(question.author) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'not author of questions' do
      before { login(user) }

      it 'try to deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirect to root path' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'POST #vote_up' do
    let!(:question) { create(:question) }

    context 'author of questions' do
      before { login(question.author) }

      it 'vote up for question' do
        post :vote_up, params: { id: question }, format: :js
        expect(question.votes_sum).to eq 0
      end
    end

    context 'not author of questions' do
      before { login(user) }

      it 'vote up for question' do
        post :vote_up, params: { id: question }, format: :js
        expect(question.votes_sum).to eq 1
      end
    end
  end

  describe 'POST #vote_down' do
    let!(:question) { create(:question) }

    context 'author of questions' do
      before { login(question.author) }

      it 'vote down for question' do
        post :vote_down, params: { id: question }, format: :js
        expect(question.votes_sum).to eq 0
      end
    end

    context 'not author of questions' do
      before { login(user) }

      it 'vote down for question' do
        post :vote_down, params: { id: question }, format: :js
        expect(question.votes_sum).to eq(-1)
      end
    end
  end

  describe 'POST #comment' do
    let!(:question) { create(:question) }
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new comment in the database' do
        expect { post :comment, params: { comment: attributes_for(:comment), commentable: question, id: question.id, format: :js } }.to change(Comment, :count).by(1)
      end
      it 'assign author' do
        post :comment, params: { comment: attributes_for(:comment), id: question.id, format: :js }
        expect(user).to be_author_of(assigns(:comment))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the comment' do
        expect { post :comment, params: { comment: attributes_for(:comment, :invalid), commentable: question, id: question.id, format: :js } }.to_not change(Comment, :count)
      end
    end
  end
end
