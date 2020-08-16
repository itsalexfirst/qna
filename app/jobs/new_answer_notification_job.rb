class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NewAnswerNotificationService.notification(answer)
  end
end
