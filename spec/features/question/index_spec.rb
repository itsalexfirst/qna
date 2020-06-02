require 'rails_helper'

feature 'User can see questions list', %q{
  In order to see questions of community
  As an guest or authenticated user
  I`d like to be able to get questions list
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }


  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
    end

    scenario 'get list of question' do
      questions.each do |question|
        expect(page).to have_content question.title
      end
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit questions_path
    end

    scenario 'get list of question' do
      questions.each do |question|
        expect(page).to have_content question.title
      end
    end
  end
end
