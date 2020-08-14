require 'rails_helper'

feature 'User can sign up', "
  In order to ask questions
  As an unregistred user
  I'd Like to be able sign up
" do
  given(:user) { create(:user) }

  background { visit root_path }

  scenario 'Authenticated user tries to sign up' do
    sign_in(user)
    expect(page).to_not have_link 'Sign up'
  end

  describe 'Unregistered user' do
    scenario 'tries to sign up' do
      click_link 'Sign up'
      fill_in 'Email', with: 'new@mail.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_button 'Sign up'

      expect(page).to have_content 'A message with a confirmation link has been sent to your email address'
    end

    scenario 'confirm email' do
      click_link 'Sign up'
      fill_in 'Email', with: 'new@mail.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_button 'Sign up'

      open_email('new@mail.com')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed'
    end

    scenario 'tries to sign up with error' do
      click_link 'Sign up'
      click_button 'Sign up'

      expect(page).to have_content "Email can't be blank"
    end
  end

  scenario 'User tries to sign up with registered email' do
    click_link 'Sign up'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_button 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
