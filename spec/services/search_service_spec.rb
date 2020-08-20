require 'rails_helper'

RSpec.describe SearchService do
  let(:resources_list) { %w[Question Answer Comment User] }

  let(:search_params) { { keywords: 'myContent', resource: resources_list } }

  it 'search in all resource' do
    resource = search_params[:resource] || %w[Question Answer Comment User]
    keywords = ThinkingSphinx::Query.escape(search_params[:keywords])

    expect(ThinkingSphinx).to receive(:search).with(keywords, :classes => resource.map { |x| x.classify.constantize }).and_call_original
    SearchService.call(search_params)
  end

  it 'search in one resource' do
    resources_list.each do |res|
      resource = [res]
      search_params = { keywords: 'myContent', resource: resource }
      keywords = ThinkingSphinx::Query.escape(search_params[:keywords])

      expect(ThinkingSphinx).to receive(:search).with(keywords, :classes => resource.map { |x| x.classify.constantize }).and_call_original
      SearchService.call(search_params)
    end
  end
end
