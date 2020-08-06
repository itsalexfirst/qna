require 'rails_helper'

feature 'User created comment appeared for another user', %q{
  In order to to provide additional information
  As an authenticated user
  I`d like to be able to comment selected resource and it appeared for another user
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe "Multiple sessions", js: true do
    scenario "questions comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within "#question-#{question.id}-comments" do
          click_on 'Add comment'
          fill_in 'Body', with: 'test comment'

          click_on 'Comment'
        end

        sleep(5)

        expect(page).to have_content 'test comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'test comment'
      end
    end

    scenario "answers comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within "#answer-#{answer.id}-comments" do
          click_on 'Add comment'
          fill_in 'Body', with: 'test comment'

          click_on 'Comment'
        end

        sleep(5)

        expect(page).to have_content 'test comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'test comment'
      end
    end
  end
end
