require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:user) { create :user }
  let(:question) { create :question, author: user }
  let(:answer) { create :answer, question: question }

  it 'calls NewAnswerNotificationService#notification' do
    expect(NewAnswerNotificationService).to receive(:notification).with(answer)
    NewAnswerNotificationJob.perform_now(answer)
  end
end
