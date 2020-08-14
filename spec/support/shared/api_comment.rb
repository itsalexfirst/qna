shared_examples_for 'API Commentable' do

  context 'comment' do

    it 'returns list of comments' do
      expect(resource_with_comments_response.size).to eq 3
    end

    it 'returns all public fields' do
      %w[body].each do |attr|
        expect(resource_with_comments_response.last[attr]).to eq comment.send(attr).as_json
      end
    end
  end
end
