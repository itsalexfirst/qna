require 'rails_helper'

feature 'User created answer appeared for another user', '
  In order to answer a question from community quickly
  As an authenticated user
  I`d like to be able to answer selected question and it appeared for another user
' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:test_url) { 'https://yandex.ru' }

  describe 'Multiple sessions', js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'test answer'

        attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]

        fill_in 'Link name', with: 'Test link'
        fill_in 'Url', with: test_url

        click_on 'Answer'

        sleep(5)

        expect(page).to have_content 'test answer'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'

        expect(page).to have_link 'Test link', href: test_url
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'test answer'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'

        expect(page).to have_link 'Test link', href: test_url
      end
    end
  end
end
