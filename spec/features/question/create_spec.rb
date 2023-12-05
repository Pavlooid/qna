require "rails_helper"

feature 'User can create question', %q{
  To get answer from community
  As an authorized user
  I'd like to be able to ask question
} do

  given(:user) { create(:user) }

  describe 'Authorized user' do

    background do
      sign_in(user)
      
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks question' do
      fill_in 'Title', with: 'Ruby'
      fill_in 'Body', with: 'Code'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Ruby'
      expect(page).to have_content 'Code'
    end

    scenario 'asks question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthorized user tries to ask question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
