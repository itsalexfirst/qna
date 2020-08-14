class AnswersSerializer < ActiveModel::Serializer
  attributes %i[id body created_at updated_at]
  belongs_to :author
end
