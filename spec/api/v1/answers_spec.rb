require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  let(:question) { create(:question) }
  let(:another_user) { create(:user) }
  let(:another_access_token) { create(:access_token, resource_owner_id: another_user.id) }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['author']['id']).to eq answer.author.id
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    let(:access_token) { create(:access_token) }
    let!(:answer) { create(:answer, :with_file) }
    let(:answer_response) { json['answer'] }

    let!(:comments) { create_list(:comment, 3, commentable: answer) }
    let(:comment) { comments.first }

    let!(:links) { create_list(:link, 3, linkable: answer) }
    let(:link) { links.last }

    let(:file) { answer.files.first }

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it_behaves_like 'API Commentable' do
      let(:resource_with_comments_response) { answer_response['comments'] }
    end

    it_behaves_like 'API Linkable' do
      let(:resource_with_links_response) { answer_response['links'] }
    end

    it_behaves_like 'API Attachable' do
      let(:resource_with_files_response) { answer_response['files'] }
    end

    describe 'POST /api/v1/questions/:question_id/answers' do
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
      let(:method) { :post }

      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it_behaves_like 'API Authorizable' do
        let(:method) { :post }
      end

      it_behaves_like 'API Create Resource', Answer do
        let(:create_attrs) { { body: 'New body', question_id: question.id } }
      end
    end

    describe 'PUT /api/v1/answers/:id' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:answer) { create(:answer, question: question, author: user) }

      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :patch }

      it_behaves_like 'API Authorizable' do
        let(:method) { :patch }
      end

      it_behaves_like 'API Update Resource', Answer do
        let(:update_attrs) { { body: 'Updated body' } }
        let(:invalid_attrs) { { body: nil } }
      end
    end

    describe 'DELETE /api/v1/answers/:id' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:answer) { create(:answer, question: question, author: user) }

      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :delete }

      it_behaves_like 'API Authorizable' do
        let(:method) { :delete }
      end

      it_behaves_like 'API Delete Resource', Answer
    end
  end
end
