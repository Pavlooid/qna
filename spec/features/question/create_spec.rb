require "rails_helper"

feature 'User can create question', %q{
  To get answer from community
  As an authorized user
  I'd like to be able to ask question
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }

  describe 'Authorized user' do
    background do
      sign_in(user)
      
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks question' do
      fill_in 'Title', with: 'Ruby', match: :first
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

    scenario 'asks question with attached files' do
      fill_in 'Title', with: 'Ruby', match: :first
      fill_in 'Body', with: 'Code'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"], match: :first
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'multiple sessions' do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
        click_on 'Ask question'
      end

      Capybara.using_session('user2') do
        sign_in(user2)
        visit questions_path
      end

      Capybara.using_session('user') do
        fill_in 'Title', with: 'Ruby', match: :first
        fill_in 'Body', with: 'Code'
        click_on 'Ask'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'Ruby'
        expect(page).to have_content 'Code'
      end

      Capybara.using_session('user2') do
        expect(page).to have_content 'Ruby'
      end
    end
  end

  scenario 'Unauthorized user tries to ask question' do
    visit questions_path
    click_on 'Ask'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
