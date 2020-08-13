RSpec.shared_examples "API Delete Resource" do |model|
  # let(:class_str) { model.to_s.underscore }
  let(:class_sym) { model.to_s.underscore.to_sym }
  let(:old_resource) { model.first }
  let(:res_id) { old_resource.id }

  subject(:delete_resource) { delete api_path,
                                    params: { access_token: access_token.token }.to_json,
                                    headers: headers }

  describe 'author of resource' do
    describe 'deleted resource' do
      let!(:deleted_resource) { delete_resource }

      it 'returned the response 200' do
        expect(response).to be_successful
      end

      it 'delete resource' do
        expect(model.all).to_not include(old_resource)
      end
    end
  end

  context 'not author of question' do
    before { delete api_path, params: { access_token: another_access_token.token }.to_json, headers: headers }

    it 'returns 403 status' do
      expect(response.status).to eq 403
    end

    it 'not delete resource' do
      expect(model.all).to include(old_resource)
    end
  end
end

