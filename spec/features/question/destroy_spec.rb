require 'rails_helper'

feature 'Only Author can delete question', %q{
  In order to delete question from community
  As an authenticated user
  I`d like to be able to delete my own question
} do

  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: author) }

  describe 'Authenticated user', js: true do
    scenario 'as Author can delete own question' do
      sign_in(author)
      visit question_path(question)

      page.accept_alert 'Are you sure?' do
        click_on 'Delete'
      end

      expect(page).to_not have_content question.title
      expect(page).to have_content 'Your question successfully deleted.'
    end

    scenario 'as Author can delete attached files of question' do
      sign_in(author)
      question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      visit question_path(question)

      page.accept_alert 'Are you sure?' do
        click_on 'Delete file'
      end

      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario 'as NOT Author tries to delete someone question' do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Unauthenticated user tries to delete someone question', js: true do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to_not have_link 'Delete'
  end

end
