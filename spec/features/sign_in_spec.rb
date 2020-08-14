require 'rails_helper'

feature 'User can sign in', "
  In order to ask questions
  As an unauthenticated user
  I'd Like to be able sign in
" do
  given(:user) { create(:user) }
  given(:user_unconfirmed) { create(:user, confirmed_at: nil) }

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

  scenario 'User with unconfirmed email tries to sign in' do
    fill_in 'Email', with: user_unconfirmed.email
    fill_in 'Password', with: user_unconfirmed.password
    click_button 'Log in'

    expect(page).to have_content 'You have to confirm your email address before continuing.'
  end

  scenario 'Registered user tries to sign in with Github account' do
    mock_auth_github
    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Successfully authenticated from github account.'
  end

  scenario 'User can handle authentication error' do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Invalid credentials'
  end

  scenario 'Registered user tries to sign in with Yandex account without provided email' do
    mock_auth_yandex
    click_on 'Sign in with Yandex'
    expect(page).to have_content 'update your email'
  end
end
