class SearchService
  def self.call(search_params)
    resource = search_params[:resource] || %w[Question Answer Comment User]
    keywords = ThinkingSphinx::Query.escape(search_params[:keywords])

    ThinkingSphinx.search keywords, :classes => resource.map { |x| x.classify.constantize }
  end
end
