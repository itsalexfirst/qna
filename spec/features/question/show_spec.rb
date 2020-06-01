require 'rails_helper'

feature 'User can see question and answers', %q{
  In order to see questions and answers of community
  As an guest or authenticated user
  I`d like to be able to see question and its answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create_list(:answer, 3, question: question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'tries to see question and answers' do
      expect(page).to have_content question.title
      expect(page).to have_content question.body

      question.answers.each do |answer|
        expect(page).to have_content answer.body
      end
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
    end

    scenario 'tries to see question and answers' do
      expect(page).to have_content question.title
      expect(page).to have_content question.body

      question.answers.each do |answer|
        expect(page).to have_content answer.body
      end
    end
  end
end