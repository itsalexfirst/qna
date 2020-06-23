require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:awards) { create_list(:award, 3, user: user) }

    before do
      sign_in(user)
      get :index
    end

    it 'populates an array of all awards' do
      expect(assigns(:awards)).to match_array(awards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
