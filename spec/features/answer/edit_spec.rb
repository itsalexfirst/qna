require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author user
  I`d like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given(:not_user_answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    scenario 'edits his answer' do
      sign_in user
      visit question_path(question)

      click_on 'Edit Answer'

      within '.answers' do
        fill_in 'Body', with: 'edit text'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edit text'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      sign_in user
      visit question_path(question)

      click_on 'Edit Answer'
      within '.answers' do
        fill_in 'Body', with: ''
        click_on 'Save'
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to edit other users answer' do
      sign_in not_author
      visit question_path(question)

      expect(page).to_not have_link 'Edit Answer'
    end
  end

  scenario 'Unauthenticated user tries to edits answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit Answer'
  end
end
