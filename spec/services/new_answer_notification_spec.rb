require 'rails_helper'

RSpec.describe NewAnswerNotificationService do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:another_user) { create(:user) }
  let!(:subscription) { create(:subscription, question: question, user: another_user) }
  let(:answer) { create(:answer, question: question) }

  it 'sends notification to author and subscribed user' do
    expect(NewAnswerNotificationMailer).to receive(:notification).with(answer, user).and_call_original
    expect(NewAnswerNotificationMailer).to receive(:notification).with(answer, another_user).and_call_original
    NewAnswerNotificationService.notification(answer)
  end
end
