require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:link) { create(:link, linkable: question) }

    context 'author of question link' do
      before { login(question.author) }

      it 'deletes link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to change(question.links, :count).by(-1)
      end

      it 'render template destroy' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'not author of questions link' do
      before { login(user) }

      it 'try to deletes link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to_not change(question.links, :count)
      end

      it 'return forbidden' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
