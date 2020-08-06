require 'rails_helper'

feature 'User created question appeared for another user', %q{
  In order to qet answer from community quickly
  As an authenticated user
  I`d like to be able to ask the question and it appeared for another user
} do

  given(:user) { create(:user) }
  given(:test_url) { 'https://yandex.ru' }

  describe "Multiple sessions", js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'test text'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        fill_in 'Link name', with: 'Test link'
        fill_in 'Url', with: test_url

        fill_in 'Award name', with: 'Test award'
        attach_file 'Award image', "#{Rails.root}/public/apple-touch-icon.png"


        click_on 'Ask'

        sleep(5)

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test text'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'

        expect(page).to have_link 'Test link', href: test_url

        expect(page).to have_css('img')


      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'

        expect(page).to have_link 'Test link', href: test_url

        expect(page).to have_css('img')

        expect(page).to have_link 'Answers'
      end
    end
  end
end
