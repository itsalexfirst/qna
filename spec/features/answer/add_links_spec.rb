require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional information
  As an answer author
  I`d like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/itsalexfirst/da7bbbaf7c2863b2ffbe5935e4b8cb21' }

  scenario 'User adds link when ask question', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'text text'

    fill_in 'Link name', with: 'Test link'
    fill_in 'Url', with: gist_url
    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'Test link', href: gist_url
    end
  end
end
