require 'rails_helper'

feature 'User can select best answer', %q{
  In order to select answer as best
  As an author of question
  I`d like to be able choose best answer
} do

  given!(:author) { create(:user) }

  given!(:authors_question) { create(:question, author: author) }
  given!(:question) { create(:question) }

  given!(:authors_question_answer) { create_list(:answer, 3, question: authors_question) }
  given!(:answer) { create_list(:answer, 3, question: question) }

  describe 'Authenticated user', js: true do

    background { sign_in(author) }

    scenario 'choose best question for his answer' do
      visit question_path(authors_question)

      expect(page).to have_link 'Best'
    end

    scenario 'tries to choose best question for someone answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Best'
    end
  end

  scenario 'Unauthenticated user tries to choose best question', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Best'
  end
end
