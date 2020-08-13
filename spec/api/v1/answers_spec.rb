require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {{"CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json'}}

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
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
  end
end
