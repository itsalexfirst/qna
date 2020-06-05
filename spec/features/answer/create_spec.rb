require 'rails_helper'

feature 'User can create answer', %q{
  In order to answer a question from community
  As an authenticated user
  I`d like to be able to answer selected question on its page
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answer a question' do
      fill_in 'Body', with: 'test text'
      click_on 'Answer'

      expect(page).to have_content question.body
      expect(page).to have_content 'test text'
    end

    scenario 'asks a question with errors' do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
