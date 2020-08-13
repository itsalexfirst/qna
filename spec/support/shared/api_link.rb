shared_examples_for 'API Linkable' do

  context 'link' do

    it 'returns list of links' do
      expect(resource_with_links_response.size).to eq 3
    end

    it 'returns all public fields' do
      %w[name url].each do |attr|
        expect(resource_with_links_response.first[attr]).to eq link.send(attr).as_json
      end
    end
  end
end
