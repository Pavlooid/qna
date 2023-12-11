require "rails_helper"

feature 'User can delete question', %q{
  As an authorized user
  I'd like to be able to delete my own question
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Author of question delete it' do
    sign_in(user)
    visit questions_path
    click_on 'Delete'

    expect(page).to have_content 'Question was successfully deleted.'
  end

  scenario 'Not creator of question tries to delete it' do
    sign_in(user2)
    visit questions_path
    click_on 'Delete'

    expect(page).to have_content 'Question was not created by you.'
  end

  scenario 'Unauthorized user tries to delete question' do
    visit questions_path
    click_on 'Delete'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
