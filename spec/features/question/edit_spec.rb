require "rails_helper"
  
feature 'User can edit his own question', %q{
  In order to edit question
  As an authorized user
  I'd like to be able to edit my own question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authorized user' do
    before do
      sign_in(user)
      visit questions_path
      click_on 'Edit'
    end

    scenario 'edit question', js: true do 
      fill_in 'Your title', with: 'New title'
      fill_in 'Your body', with: 'New body'
      click_on 'Save'

      expect(page).to have_content 'New title'
      expect(page).to have_content 'New body'
    end

    scenario 'edit not his own question' do

    end

  end

  scenario 'Unauthorized user tries to edit question' do

  end
end
