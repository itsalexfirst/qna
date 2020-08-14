class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true
end
