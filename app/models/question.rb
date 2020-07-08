class Question < ApplicationRecord
  include Votable

  has_many :answers, -> { order('best DESC') }, dependent: :destroy
  belongs_to :author, class_name: 'User'
  has_many :links, dependent: :destroy, as: :linkable
  has_one :award, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true

  def best_answer
    answers.best
  end
end
