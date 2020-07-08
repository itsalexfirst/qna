require 'rails_helper'

feature 'User can add award to question', %q{
  In order to provide some stuff
  As an question author
  I`d like to be able to add award
} do
  given(:user) { create(:user) }

  scenario 'User adds award when ask question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'

    fill_in 'Award name', with: 'Test award'
    attach_file 'Award image', "#{Rails.root}/public/apple-touch-icon.png"
    click_on 'Ask'

    expect(page).to have_css('img')
  end
end
