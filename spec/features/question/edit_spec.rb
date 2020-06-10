require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author user
  I`d like to be able to edit my question
} do

  given!(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:not_user_question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given(:not_user_answer) { create(:answer, question: question) }

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
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
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

    scenario 'tries to edit other users answer' do
      sign_in user
      visit root_path

      within "#question-#{not_user_question.id}" do
        expect(page).to_not have_link 'Edit Question'
      end
    end
  end

  scenario 'Unauthenticated user tries to edits answer' do
    visit root_path

    expect(page).to_not have_link 'Edit Question'
  end
end
