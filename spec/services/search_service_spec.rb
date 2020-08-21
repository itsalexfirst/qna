require 'rails_helper'

RSpec.describe SearchService do
  let(:resources_list) { %w[Question Answer Comment User] }

  let(:search_params) { { keywords: 'keyword', resource: resources_list } }

  it 'search in all resource' do
    keywords = ThinkingSphinx::Query.escape(search_params[:keywords])

    expect(ThinkingSphinx).to receive(:search).with(keywords, :classes => [Question, Answer, Comment, User]).and_call_original
    SearchService.call(search_params)
  end

  it 'search in one resource' do
    resources_list.each do |res|
      search_params = { keywords: 'keyword', resource: [res] }
      resource = res.classify.constantize
      keywords = ThinkingSphinx::Query.escape(search_params[:keywords])

      expect(ThinkingSphinx).to receive(:search).with(keywords, :classes => [resource]).and_call_original
      SearchService.call(search_params)
    end
  end
end
