require "rails_helper"

feature 'User can create answer', %q{
  To publish answer
  As an authorized user
  I'd like to be able answer question
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authorized user', js: true do

    background do
      sign_in(user)
      
      visit question_path(question)
    end

    scenario 'asks answer', js: true do
      fill_in 'Add answer', with: 'My first answer'
      click_on 'Answer'

      expect(page).to have_content 'My first answer'
    end

    scenario 'asks answer with errors', js: true do
      fill_in 'Add answer', with: ''
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'asks answer with attached files', js: true do
      fill_in 'Add answer', with: 'Code'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'multiple sessions' do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path(question)
      end

      Capybara.using_session('user2') do
        sign_in(user2)
        visit questions_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Add answer', with: 'My second answer'
        click_on 'Answer'

        expect(page).to have_content 'My second answer'
      end

      Capybara.using_session('user2') do
        expect(page).to have_content 'My second answer'
        expect(page).to have_content 'Rating: 0'
      end
    end
  end
end
