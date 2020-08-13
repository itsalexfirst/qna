class QuestionSerializer < ActiveModel::Serializer
  attributes %i[id title body created_at updated_at short_title]
  has_many :answers
  belongs_to :author

  def short_title
    object.title.truncate(5)
  end
end
