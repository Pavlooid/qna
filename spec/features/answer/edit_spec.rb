require "rails_helper"

feature 'User can edit his own answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, author: user, question: question) }

  scenario 'Unauthorized can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authorized user' do
    scenario 'edits his answer', js: true do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'another answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'another answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit not his own answer' do

    end

    scenario 'edit his answer with errors'
  end
end
