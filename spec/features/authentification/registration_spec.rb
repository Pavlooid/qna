require "rails_helper"

feature 'User can register', %q{
  In order to use service
  As an unregistered user
  I'd like to be able to register
} do

  background { visit new_user_registration_path }

  scenario 'Registration with valid params' do
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Registration with invalid params' do
    fill_in 'Email', with: ''
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    
    expect(page).to have_content '1 error prohibited this user from being saved:'
    expect(page).to have_content "Email can't be blank"
  end
end
