require 'rails_helper'

feature 'Only Author can delete answer', %q{
  In order to delete answer from community
  As an authenticated user
  I`d like to be able to delete my own answer
} do

  given!(:author) { create(:user) }
  given!(:user) { create(:user) }

  given!(:authors_question) { create(:question, author: author) }
  given!(:authors_answer) { create(:answer, question: authors_question, author: author) }

  given!(:users_question) { create(:question, author: user) }
  given!(:users_answer) { create(:answer, question: users_question, author: user) }



  describe 'Authenticated user' do
    scenario 'as Author can delete own answer', js: true do
      sign_in(author)
      visit question_path(authors_question)
      expect(page).to have_content authors_answer.body

      page.accept_alert 'Are you sure?' do
        click_on 'Delete Answer'
      end

      expect(page).to have_content authors_answer.body
      expect(page).to_not have_content authors_answer.body
    end

    scenario 'as NOT Author tries to delete someone answer', js: true do
      sign_in(author)
      visit question_path(users_question)

      expect(page).to have_content users_answer.body
      expect(page).to_not have_link 'Delete Answer'
    end
  end

  scenario 'Unauthenticated user tries to delete someone answer', js: true do
    visit question_path(authors_question)

    expect(page).to have_content authors_answer.body
    expect(page).to_not have_link 'Delete Answer'
  end

end
