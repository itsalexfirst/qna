require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  let!(:questions) { create_list(:question, 2) }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end


  end

end



