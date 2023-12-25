require "rails_helper"
  
feature 'User can edit his own question', %q{
  In order to edit question
  As an authorized user
  I'd like to be able to edit my own question
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authorized user' do
    background do
      sign_in(user) 
      visit questions_path

      click_on 'Edit'
    end

    scenario 'edit his own question', js: true do 
      fill_in 'Your title', with: 'New title'
      fill_in 'Your body', with: 'New body'
      click_on 'Save'

      expect(page).to have_content 'New title'
      expect(page).to have_content 'New body'
    end

    scenario 'edit his own question by adding new file', js: true do
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Save'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Authorized user tries to edit not his own question' do
    sign_in(user2)
    visit questions_path
    expect(page).to_not have_content 'Edit'
  end

  scenario 'Unauthorized user tries to edit question' do
    visit questions_path
    expect(page).to_not have_content 'Edit'
  end
end
