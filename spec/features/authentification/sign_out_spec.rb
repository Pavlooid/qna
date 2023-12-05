require 'rails_helper'

feature 'User can sign out', %q{
  As an authorized user
  I'd like to be able to sign out
  By using 'Sign out' button
} do

  given(:user) { create(:user) }

  scenario 'Authorized user logout' do
    sign_in(user)

    click_on 'Sign out'
    visit new_question_path

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario "Unauthorized user can't logout " do
    visit questions_path

    expect(page).to have_no_content 'Sign out'
  end
end
