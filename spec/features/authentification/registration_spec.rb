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
    click_on 'Sign up', match: :first

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Registration with invalid params' do
    fill_in 'Email', with: ''
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up', match: :first
    
    expect(page).to have_content '1 error prohibited this user from being saved:'
    expect(page).to have_content "Email can't be blank"
  end

  describe 'Register with Omniauth services' do
    describe 'GitHub' do
      scenario 'with correct data' do
        mock_auth_hash('github', email: '123@mail.ru')
        click_button 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account.'
      end

      scenario 'can handle authentication error with GitHub' do
        invalid_mock('github')
        click_button 'Sign in with GitHub'
        expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials"'
      end
    end

    describe 'Vkontakte' do
      scenario "with correct data" do
        mock_auth_hash('vkontakte', email: '123@mail.ru')
        click_button 'Sign in with Vkontakte'
        expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
      end

      scenario "with no email" do
        mock_auth_hash('vkontakte', email: nil)
        click_button 'Sign in with Vkontakte'

        fill_in 'Email', with: '123@mail.ru'
        click_on 'Sign up', match: :first
        expect(page).to have_content 'Welcome! You have signed up successfully.'
      end

      scenario 'can handle authentication error with Vkontakte' do
        invalid_mock('vkontakte')
        click_button "Sign in with Vkontakte"

        expect(page).to have_content 'Could not authenticate you from Vkontakte because "Invalid credentials"'
      end
    end
  end
end
