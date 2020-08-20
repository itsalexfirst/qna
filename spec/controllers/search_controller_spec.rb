require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do

  let!(:questions) { create_list(:question, 2) }
  let!(:user) { create(:user) }

  describe "GET #index", sphinx: true, js: true do
    before do
      login(user)
      allow(SearchService).to receive(:call).and_call_original
      allow(SearchService).to receive(:call).with('keywords' => 'keywords', 'resource' => ['Question']).and_return(questions)

      get :index, params: { search: { keywords: 'keywords', resource: ['Question'] } }
    end

    it 'get array of resources' do
      expect(assigns(:search_result)).to match_array(questions)
      expect(assigns(:keywords)).to eq 'keywords'
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end
end





