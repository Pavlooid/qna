require "rails_helper"

feature 'User can create answer', %q{
  To publish answer
  As an authorized user
  I'd like to be able answer question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authorized user' do

    background do
      sign_in(user)
      
      visit question_path(question)
    end

    scenario 'asks question', js: true do
      fill_in 'Body', with: 'My first answer'
      click_on 'Answer'

      expect(page).to have_content 'My first answer'
    end

    scenario 'asks question with errors', js: true do
      fill_in 'Body', with: ''
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end
end
