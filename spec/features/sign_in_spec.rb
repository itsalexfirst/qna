require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd Like to be able sign in
} do

  given(:user) { create(:user) }

  background do
    visit root_path
    click_link 'Log in'
  end
  
  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@mail.com'
    fill_in 'Password', with: 'password'
    click_button 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end

