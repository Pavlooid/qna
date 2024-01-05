require "rails_helper"

feature 'User can create answer', %q{
  To publish answer
  As an authorized user
  I'd like to be able answer question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authorized user', js: true do

    background do
      sign_in(user)
      
      visit question_path(question)
    end

    scenario 'asks answer', js: true do
      fill_in 'Body', with: 'My first answer'
      click_on 'Answer'

      expect(page).to have_content 'My first answer'
    end

    scenario 'asks answer with errors', js: true do
      fill_in 'Body', with: ''
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'asks answer with attached files', js: true do
      fill_in 'Body', with: 'Code'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end
end
