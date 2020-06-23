require 'rails_helper'

feature 'Only Author can delete answer link', %q{
  In order to delete answer link from community
  As an authenticated user
  I`d like to be able to delete my own answer link
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question)}
  given!(:link) { create(:link, linkable: answer) }

  describe 'Authenticated user', js: true do
    scenario 'as Author can delete own answer link' do
      sign_in(answer.author)
      visit question_path(question)

      page.accept_alert 'Are you sure?' do
        click_on 'Delete link'
      end

      expect(page).to_not have_link link.name
    end


    scenario 'as NOT Author tries to delete someone answer link' do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to_not have_link 'Delete link'
    end
  end

  scenario 'Unauthenticated user tries to delete someone answer link', js: true do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to_not have_link 'Delete link'
  end

end
