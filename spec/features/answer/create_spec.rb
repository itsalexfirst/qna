require 'rails_helper'

feature 'User can create answer', %q{
  In order to answer a question from community
  As an authenticated user
  I`d like to be able to answer selected question on its page
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answer a question' do
      fill_in 'Body', with: 'test text'
      click_on 'Answer'

      expect(page).to have_content question.body
      expect(page).to have_content 'test text'
    end

    scenario 'answer a question with attached file' do
      fill_in 'Body', with: 'test text'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question with errors' do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer a question', js: true do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to_not have_link 'Answer'
  end
end
