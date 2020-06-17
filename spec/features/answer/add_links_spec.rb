require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional information
  As an answer author
  I`d like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/itsalexfirst/da7bbbaf7c2863b2ffbe5935e4b8cb21' }

  scenario 'User adds link when add answer', js: true do
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

  scenario 'User adds links when add answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'text text'

    click_on 'add link'

    all('.nested-fields').each do |f|
      within(f) do
        fill_in 'Link name', with: 'Test link'
        fill_in 'Url', with: gist_url
      end
    end
    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'Test link', href: gist_url, count: 2
    end
  end

  scenario 'User adds link when add answer with error', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'text text'

    fill_in 'Link name', with: 'Test link'
    click_on 'Answer'

    expect(page).to have_content 'Links url is invalid'
  end
end
