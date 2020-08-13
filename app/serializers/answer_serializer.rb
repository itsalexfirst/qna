class AnswerSerializer < ActiveModel::Serializer
  attributes %i[id body author_id files created_at updated_at]
  has_many :links
  has_many :comments

  def files
    object.publish_files
  end
end
