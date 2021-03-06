require 'rails_helper'

feature 'User can add links to question', '
  In order to provide additional information
  As an question author
  I`d like to be able to add links
' do
  given(:user) { create(:user) }
  given(:test_url) { 'https://yandex.ru' }
  given(:gist_url) { 'https://gist.github.com/itsalexfirst/da7bbbaf7c2863b2ffbe5935e4b8cb21' }

  scenario 'User adds link when ask question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'

    fill_in 'Link name', with: 'Test link'
    fill_in 'Url', with: test_url
    click_on 'Ask'

    expect(page).to have_link 'Test link', href: test_url
  end

  scenario 'User adds link to gist when ask question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'

    fill_in 'Link name', with: 'Gist link'
    fill_in 'Url', with: gist_url
    click_on 'Ask'

    expect(page).to_not have_link 'Gist link', href: gist_url
    expect(page).to have_content 'test gist'
  end

  scenario 'User adds links when ask question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'

    click_on 'add link'

    all('.nested-fields').each do |f|
      within(f) do
        fill_in 'Link name', with: 'Test link'
        fill_in 'Url', with: test_url
      end
    end
    click_on 'Ask'

    expect(page).to have_link 'Test link', href: test_url, count: 2
  end

  scenario 'User adds link when ask question with error', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'

    fill_in 'Link name', with: 'Test link'
    click_on 'Ask'

    expect(page).to have_content 'Links url is invalid'
  end
end
