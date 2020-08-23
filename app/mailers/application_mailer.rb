class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials[Rails.env.to_sym][:smtp][:user]
  layout 'mailer'
end
