class NewAnswerNotificationService
  def self.notification(answer)
    answer.question.subscribed_users.find_each do |user|
      NewAnswerNotificationMailer.notification(answer, user).deliver_later
    end
  end
end
