class NewAnswerNotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.new_answer_notification_mailer.notification.subject
  #
  def notification(answer, user)
    @greeting = "Hi"
    @question = answer.question
    @answer = answer

    mail to: user.email
  end
end
