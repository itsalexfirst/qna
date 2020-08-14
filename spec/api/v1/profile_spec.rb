require 'rails_helper'

describe 'Profile API', type: :request do
  let(:headers) do
    { 'CONTENT TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200' do
        expect(response).to be_successful
      end

      it 'return all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:users) { create_list(:user, 4) }
      let(:me) { users.first }
      let(:user) { users.last }
      let(:user_response) { json['users'].last }

      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200' do
        expect(response).to be_successful
      end

      it 'return all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(user_response[attr]).to eq user.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(user_response).to_not have_key(attr)
        end
      end

      it 'does not return authenticated user' do
        json['users'].each do |user|
          expect(user['id']).not_to eq me.id.as_json
        end
      end

      it 'returns list of users' do
        expect(json['users'].size).to eq 3
      end
    end
  end
end
