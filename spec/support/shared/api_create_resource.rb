RSpec.shared_examples 'API Create Resource' do |model|
  # let(:class_str) { model.to_s.underscore }
  let(:class_sym) { model.to_s.underscore.to_sym }

  subject(:create_resource) do
    post api_path, params: { access_token: access_token.token, class_sym => create_attrs }.to_json, headers: headers
  end

  describe 'created resource' do
    it 'creates new resource' do
      expect { create_resource }.to change { model.all.size }.by(1)
    end

    describe 'created resource' do
      let!(:new_resource) do
        create_resource
        id = model.all.ids.last
        expect(id).to_not be_nil
        model.find(id)
      end

      it 'returned the response 201' do
        expect(response).to be_successful
      end

      it 'is assigned to the current user' do
        expect(new_resource.author).to eq user
      end

      it 'returns resource data' do
        expect(new_resource).to have_attributes(create_attrs)
      end
    end
  end
end
