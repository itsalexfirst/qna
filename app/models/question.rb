class Question < ApplicationRecord
  has_many :answers, -> { order('best DESC') }, dependent: :destroy
  belongs_to :author, class_name: 'User'

  has_one_attached :file

  validates :title, :body, presence: true

  def best_answer
    answers.best
  end
end
