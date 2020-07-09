class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  scope :best, -> { where(best: true).take }

  def best!
    Answer.transaction do
      question.best_answer&.update(best: false)
      update!(best: true)
      question.award&.update!(user: author)
    end
  end
end
