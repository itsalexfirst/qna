class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials[:smtp][:user]
  layout 'mailer'
end
