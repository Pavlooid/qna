require 'rails_helper'

feature 'User can add comments to question', %q{
  In order to provide additional info to question
  As an authorized user
  I'd like to be able to add comments
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authorized user adds comment to answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: "Ruby", match: :first
    click_on 'Add comment'

    expect(page).to have_content "Ruby"
  end

  scenario "Authorized user can't add comment", js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Add comment'
  end
end
