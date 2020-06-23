require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author user
  I`d like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given(:not_user_answer) { create(:answer, question: question) }
  given(:test_url) { 'https://yandex.ru' }

  describe 'Authenticated user', js: true do
    scenario 'edits his answer' do
      sign_in user
      visit question_path(question)

      click_on 'Edit Answer'

      within '.answers' do
        fill_in 'Body', with: 'edit text'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edit text'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit answer with attached file' do
      sign_in user
      visit question_path(question)

      click_on 'Edit Answer'

      within '.answers' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'add link while edits his answer' do
      sign_in user
      visit question_path(question)

      click_on 'Edit Answer'

      within '.answers' do
        click_on 'add link'
        fill_in 'Link name', with: 'Test link'
        fill_in 'Url', with: test_url
        click_on 'Save'
      end

      expect(page).to have_link 'Test link', href: test_url
    end

    scenario 'edits his answer with errors' do
      sign_in user
      visit question_path(question)

      click_on 'Edit Answer'
      within '.answers' do
        fill_in 'Body', with: ''
        click_on 'Save'
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to edit other users answer' do
      sign_in not_author
      visit question_path(question)

      expect(page).to_not have_link 'Edit Answer'
    end
  end

  scenario 'Unauthenticated user tries to edits answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit Answer'
  end
end
