require 'rails_helper'

feature 'User can vote for question', '
  In order to mark useful question from community
  As an authenticated user
  I`d like to be able to vote for the question
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:user_question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit questions_path
    end

    scenario 'vote up for a question' do
      within "#question-#{question.id}" do
        click_on 'vote up'

        expect(page).to have_content "Rating:\n1"
      end
    end

    scenario 'vote down for a question' do
      within "#question-#{question.id}" do
        click_on 'vote down'

        expect(page).to have_content "Rating:\n-1"
      end
    end

    scenario 'tries to vote for own question' do
      within "#question-#{user_question.id}" do
        click_on 'vote up'

        expect(page).to_not have_content "Rating:\n1"
      end
    end

    scenario 'tries to vote up second time for question' do
      within "#question-#{question.id}" do
        2.times { click_on 'vote up' }

        expect(page).to have_content "Rating:\n1"
      end
    end

    scenario 'tries to vote down second time for question' do
      within "#question-#{question.id}" do
        2.times { click_on 'vote down' }

        expect(page).to have_content "Rating:\n-1"
      end
    end

    scenario 'undo vote for a question' do
      within "#question-#{question.id}" do
        click_on 'vote up'

        expect(page).to have_content "Rating:\n1"

        click_on 'vote down'

        expect(page).to have_content "Rating:\n0"
      end
    end

    scenario 'change vote to reverse for a question' do
      within "#question-#{question.id}" do
        click_on 'vote up'

        expect(page).to have_content "Rating:\n1"

        2.times { click_on 'vote down' }

        expect(page).to have_content "Rating:\n-1"
      end
    end
  end

  scenario 'Unauthenticated user tries to vote', js: true do
    visit questions_path

    within "#question-#{question.id}" do
      click_on 'vote up'

      expect(page).to_not have_content "Rating:\n1"
    end
  end
end
