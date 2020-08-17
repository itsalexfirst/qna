require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  describe 'reputatation' do
    let(:question) { create(:question) }

    it 'call ReputationService#calculate' do
      expect(ReputationService).to receive(:calculate).with(question)
      ReputationJob.perform_now(question)
    end
  end
end
