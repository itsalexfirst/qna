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
    scenario 'as Author can delete own answer' do
      sign_in(author)
      visit question_path(authors_question)
      expect(page).to have_content authors_answer.body

      click_on 'Delete Answer'

      expect(page).to_not have_content authors_answer.body
      expect(page).to have_content 'Your answer successfully deleted.'
    end

    scenario 'as NOT Author tries to delete someone answer' do
      sign_in(author)
      visit question_path(users_question)

      expect(page).to have_content users_answer.body
      expect(page).to_not have_link 'Delete Answer'
    end
  end

  scenario 'Unauthenticated user tries to delete someone answer' do
    visit question_path(authors_question)

    expect(page).to have_content authors_answer.body
    expect(page).to_not have_link 'Delete Answer'
  end

end