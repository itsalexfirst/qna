require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    let!(:user) { create(:user) }
    let!(:file) { question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb') }

    context 'author of questions' do
      before { login(question.author) }

      it 'deletes attachment' do
        expect { delete :destroy, params: { id: question.files.first.id }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'redirect to index' do
        delete :destroy, params: { id: question.files.first.id }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'not author of questions' do
      before { login(user) }

      it 'try to deletes attachment' do
        expect { delete :destroy, params: { id: question.files.first.id }, format: :js }.to_not change(question.files, :count)
      end

      it 'return forbidden' do
        delete :destroy, params: { id: question.files.first.id }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
