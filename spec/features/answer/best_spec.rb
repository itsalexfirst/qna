require 'rails_helper'

feature 'User can select best answer', %q{
  In order to select answer as best
  As an author of question
  I`d like to be able choose best answer
} do

  given!(:author) { create(:user) }

  given!(:authors_question) { create(:question, author: author) }
  given!(:answer_one) { create(:answer, best: true, question: authors_question) }
  given!(:answer_two) { create(:answer, question: authors_question) }

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do

    background { sign_in(author) }

    scenario 'choose best question for his answer' do
      visit question_path(authors_question)

      within all(".answers")[0] do
        expect(page).to have_content answer_one.body
      end

      within "#answer-#{answer_two.id}" do
        page.accept_alert 'Are you sure?' do
          click_on 'Best'
        end
      end

      within all(".answers")[0] do
        expect(page).to have_content answer_two.body
      end
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
