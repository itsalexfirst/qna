require 'rails_helper'

feature 'Only Author can delete question link', '
  In order to delete question link from community
  As an authenticated user
  I`d like to be able to delete my own question link
' do
  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:link) { create(:link, linkable: question) }

  describe 'Authenticated user', js: true do
    scenario 'as Author can delete own question link' do
      sign_in(author)
      visit question_path(question)

      page.accept_alert 'Are you sure?' do
        click_on 'Delete link'
      end

      expect(page).to_not have_link link.name
    end

    scenario 'as NOT Author tries to delete someone question link' do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to_not have_link 'Delete link'
    end
  end

  scenario 'Unauthenticated user tries to delete someone question', js: true do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to_not have_link 'Delete link'
  end
end
