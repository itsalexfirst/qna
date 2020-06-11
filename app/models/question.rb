class Question < ApplicationRecord
  has_many :answers, -> { order('best DESC') }, dependent: :destroy
  belongs_to :author, class_name: 'User'
  has_many :links, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, :body, presence: true

  def best_answer
    answers.best
  end
end
