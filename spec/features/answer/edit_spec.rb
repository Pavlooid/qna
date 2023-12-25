require "rails_helper"

feature 'User can edit his own answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit answer
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, author: user, question: question) }

  scenario 'Unauthorized can not edit answer' do
    visit questions_path(question)

    expect(page).to_not have_content 'Edit'
  end

  describe 'Authorized user' do
    scenario 'edits his answer and and new files', js: true do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'another answer'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'another answer'
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'tries to edit not his own answer', js: true do
      sign_in(user2)
      visit question_path(question)

      expect(page).to_not have_content 'Edit'
    end
  end
end
