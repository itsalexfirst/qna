require 'rails_helper'

feature feature 'User can subscribe for new answers of question', '
  In order to receive email with new answers
  As an authenticated user
  I`d like to be able to subscribe for question and its answers
' do
  given(:question) { create :question }
  given(:user) { create(:user) }

  describe 'Authenticated user', js: true do
    scenario 'author unsubscribes to his question' do
      sign_in(question.author)
      visit question_path(question)

      within ".question-subscription" do
        expect(page).not_to have_css('#subscribe-link')
        find('#unsubscribe-link').click
        expect(page).not_to have_css('#unsubscribe-link')
      end
    end

    scenario 'subscribes to question' do
      sign_in(user)
      visit question_path(question)

      within ".question-subscription" do
        expect(page).not_to have_css('#unsubscribe-link')
        find('#subscribe-link').click
        expect(page).not_to have_css('#subscribe-link')
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to subscribes or unsubscribe' do
      visit question_path(question)

      expect(page).not_to have_css('.unsubscribe-link')
      expect(page).not_to have_css('.subscribe-link')
    end
  end
end
