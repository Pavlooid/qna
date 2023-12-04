require 'rails-helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthorized user
  I'd like to be able to sign in
} do
  scenario 'Registered user tries to sign in' do
    User.create!(email: 'user@test.com', password: '123456')

    visit '/login'
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123456'

    expect(page).to have_content 'Signed it succesfully.'
  end

  scenario 'Unregistered user tries to sign in'
end
