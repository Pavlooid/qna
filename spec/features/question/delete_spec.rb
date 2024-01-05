require "rails_helper"

feature 'User can delete question', %q{
  As an authorized user
  I'd like to be able to delete my own question
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Author of question delete it', js: true do
    sign_in(user)
    visit questions_path
    click_on 'Delete'

    expect(page).to_not have_content 'MyString'
  end

  scenario 'Not creator of question tries to delete it' do
    sign_in(user2)
    visit questions_path

    expect(page).to_not have_content 'Delete'
  end

  scenario 'Unauthorized user tries to delete question' do
    visit questions_path

    expect(page).to_not have_content 'Delete'
  end
end
