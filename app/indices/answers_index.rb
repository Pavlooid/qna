ThinkingSphinx::Index.define :answer, with: :active_record do
  # fileds
  indexes body

  # attributes
  has author_id, created_at, updated_at
end
