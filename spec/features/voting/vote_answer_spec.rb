require 'rails_helper'

feature 'User can vote for answer', '
  In order to mark useful answer from community
  As an authenticated user
  I`d like to be able to vote for the answer
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:user_answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'vote up for a answer' do
      within "#answer-#{answer.id}" do
        click_on 'vote up'

        expect(page).to have_content "Rating:\n1"
      end
    end

    scenario 'vote down for a answer' do
      within "#answer-#{answer.id}" do
        click_on 'vote down'

        expect(page).to have_content "Rating:\n-1"
      end
    end

    scenario 'tries to vote for own answer' do
      within "#answer-#{user_answer.id}" do
        click_on 'vote up'

        expect(page).to_not have_content "Rating:\n1"
      end
    end

    scenario 'tries to vote up second time for answer' do
      within "#answer-#{answer.id}" do
        2.times { click_on 'vote up' }

        expect(page).to have_content "Rating:\n1"
      end
    end

    scenario 'tries to vote down second time for answer' do
      within "#answer-#{answer.id}" do
        2.times { click_on 'vote down' }

        expect(page).to have_content "Rating:\n-1"
      end
    end

    scenario 'undo vote for a answer' do
      within "#answer-#{answer.id}" do
        click_on 'vote up'

        expect(page).to have_content "Rating:\n1"

        click_on 'vote down'

        expect(page).to have_content "Rating:\n0"
      end
    end

    scenario 'change vote to reverse for a answer' do
      within "#answer-#{answer.id}" do
        click_on 'vote up'

        expect(page).to have_content "Rating:\n1"

        2.times { click_on 'vote down' }

        expect(page).to have_content "Rating:\n-1"
      end
    end
  end

  scenario 'Unauthenticated user tries to vote', js: true do
    visit question_path(question)

    within "#answer-#{answer.id}" do
      click_on 'vote up'

      expect(page).to_not have_content "Rating:\n1"
    end
  end
end
