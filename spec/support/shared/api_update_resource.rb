RSpec.shared_examples 'API Update Resource' do |model|
  # let(:class_str) { model.to_s.underscore }
  let(:class_sym) { model.to_s.underscore.to_sym }
  let(:old_resource) { model.first }
  let(:res_id) { old_resource.id }

  subject(:update_resource) do
    patch api_path,
          params: { access_token: access_token.token, class_sym => update_attrs }.to_json,
          headers: headers
  end

  describe 'author of resource' do
    describe 'with valid params' do
      let!(:updated_resource) do
        update_resource
        model.find(res_id)
      end

      it 'returned the response 201' do
        expect(response).to be_successful
      end

      it 'update resource' do
        expect(updated_resource).to have_attributes(update_attrs)
      end
    end

    describe 'with invalid params' do
      let!(:updated_resource) do
        patch api_path, params: { access_token: access_token.token, class_sym => invalid_attrs }.to_json, headers: headers
        model.find(res_id)
      end

      it 'returned error' do
        expect(response.status).to eq 422
      end

      it 'not change resource' do
        expect(updated_resource).to eq old_resource
      end
    end
  end

  context 'not author of question' do
    before { patch api_path, params: { access_token: another_access_token.token, class_sym => update_attrs }.to_json, headers: headers }

    it 'returns 403 status' do
      expect(response.status).to eq 403
    end

    it 'not change resource' do
      expect(model.all).to include(old_resource)
    end
  end
end
