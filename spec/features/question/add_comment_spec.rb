require 'rails_helper'

feature 'User can add comments to question', %q{
  In order to provide additional info to question
  As an authorized user
  I'd like to be able to add comments
} do

  given(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given(:question) { create(:question) }

  context 'multiple sessions' do
    scenario 'Authorized user adds comment to question that can see any other user', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('user2') do
        sign_in(user2)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: "Ruby", match: :first
        click_on 'Add comment'

        expect(page).to have_content "Ruby"
      end

      Capybara.using_session('user2') do
        expect(page).to have_content "Ruby"
      end
    end
  end

  scenario "Authorized user can't add comment", js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Add comment'
  end
end
