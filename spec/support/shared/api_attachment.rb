shared_examples_for 'API Attachable' do

  context 'file' do

    it 'returns list of files' do
      expect(resource_with_files_response.size).to eq 1
    end

    it 'returns all public fields' do
      expect(resource_with_files_response.first['url']).to eq file.service_url.as_json
    end
  end
end
