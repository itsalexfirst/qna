require 'rails_helper'

feature 'User can sign out', "
  In order to close session
  As an authenticated user
  I'd Like to be able sign out
" do
  given(:user) { create(:user) }

  background { visit root_path }

  scenario 'Authenticated user tries to sign out' do
    sign_in(user)
    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unauthenticated user tries to sign out' do
    expect(page).to_not have_link 'Log out'
  end
end
