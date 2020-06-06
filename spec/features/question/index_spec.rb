require 'rails_helper'

feature 'User can see questions list', %q{
  In order to see questions of community
  As an guest or authenticated user
  I`d like to be able to get questions list
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }
  given!(:answers) { create_list(:answer, 3, question: questions.first) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit questions_path
    end

    scenario 'get list of question' do
      questions.each do |question|
        expect(page).to have_content question.title
      end
    end

    scenario 'get answers of question' do
      within "#question-#{questions.first.id}" do
        click_on 'Answers'
      end

      questions.first.answers.each do |answer|
        expect(page).to have_content answer.body
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    background do
      visit questions_path
    end

    scenario 'get list of question' do
      questions.each do |question|
        expect(page).to have_content question.title
      end
    end

    scenario 'get answers of question' do
      within "#question-#{questions.first.id}" do
        click_on 'Answers'
      end

      questions.first.answers.each do |answer|
        expect(page).to have_content answer.body
      end
    end
  end
end
