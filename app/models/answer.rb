class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  scope :best, -> { where(best: true).take }

  after_create :new_answer_notification

  def best!
    Answer.transaction do
      question.best_answer&.update(best: false)
      update!(best: true)
      question.award&.update!(user: author)
    end
  end

  def publish_files
    all_files = []
    files.each { |file| all_files.push(id: file.id, name: file.filename.to_s, url: file.service_url) }
    all_files
  end

  private

  def new_answer_notification
    NewAnswerNotificationJob.perform_later(self)
  end
end
