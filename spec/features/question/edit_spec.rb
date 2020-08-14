require 'rails_helper'

feature 'User can edit his question', '
  In order to correct mistakes
  As an author user
  I`d like to be able to edit my question
' do
  given!(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:not_user_question) { create(:question) }
  given(:test_url) { 'https://yandex.ru' }

  describe 'Authenticated user', js: true do
    scenario 'edits his question' do
      sign_in user
      visit root_path

      within "#question-#{question.id}" do
        click_on 'Edit Question'
        fill_in 'Title', with: 'edit question'
        click_on 'Save'
      end

      expect(page).to_not have_content question.title
      expect(page).to have_content 'edit question'
      expect(page).to_not have_selector 'textarea'
    end

    scenario 'attached file while edits his question' do
      sign_in user
      visit root_path

      within "#question-#{question.id}" do
        click_on 'Edit Question'
        attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
        click_on 'Save'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'add link while edits his question' do
      sign_in user
      visit root_path

      within "#question-#{question.id}" do
        click_on 'Edit Question'
        click_on 'add link'
        fill_in 'Link name', with: 'Test link'
        fill_in 'Url', with: test_url
        click_on 'Save'
      end

      expect(page).to have_link 'Test link', href: test_url
    end

    scenario 'edits his question with errors' do
      sign_in user
      visit root_path

      within "#question-#{question.id}" do
        click_on 'Edit Question'
        fill_in 'Body', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to edit other users question' do
      sign_in user
      visit root_path

      within "#question-#{not_user_question.id}" do
        expect(page).to_not have_link 'Edit Question'
      end
    end
  end

  scenario 'Unauthenticated user tries to edits question' do
    visit root_path

    expect(page).to_not have_link 'Edit Question'
  end
end
