ThinkingSphinx::Index.define :question, with: :active_record do
  #fileds
  indexes title, sortable: true
  indexes body
  indexes author.email, as: :author, sortable: true

  # attributes
  has author_id, created_at, updated_at
end
