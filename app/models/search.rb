class Search
  FILTER = ['', 'questions', 'answers', 'comments', 'users'].freeze

  def self.full_search(content, context)
    query = ThinkingSphinx::Query.escape(content)

    return [] unless FILTER.include? context

    if context == ''
      ThinkingSphinx.search query
    else
      model = context.singularize.classify.constantize
      model.search query
    end
  end
end
