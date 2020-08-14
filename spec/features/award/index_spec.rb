require 'rails_helper'

feature 'User can see awards list', '
  In order to see awards
  As authenticated user
  I`d like to be able to get my awards list
' do
  given!(:user) { create(:user) }
  given!(:award) { create(:award) }
  given!(:question) { create(:question, award: award) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:other_user) { create(:user) }

  background do
    answer.best!
    award.image.attach(io: File.open("#{Rails.root}/public/apple-touch-icon.png"), filename: 'apple-touch-icon.png')
  end

  scenario 'Author of awarded answer view awards', js: true do
    sign_in(user)
    visit questions_path

    click_on 'Awards'

    expect(page).to have_content award.question.title
    expect(page).to have_css('img')
    expect(page).to have_content award.title
  end

  scenario 'Not author of awarded answer view awards', js: true do
    sign_in(other_user)
    visit questions_path

    click_on 'Awards'

    expect(page).to_not have_content award.question.title
    expect(page).to_not have_css('img')
    expect(page).to_not have_content award.title
  end

  scenario 'Unauthenticated user tries view awards', js: true do
    visit questions_path

    expect(page).to_not have_link 'Awards'
  end
end
