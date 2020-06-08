class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true

  scope :best, -> { where(best: true).take }

  def best!
    Answer.transaction do
      question.best_answer&.update(best: false)
      update!(best: true)
    end
  end
end
