require "rails_helper"

feature 'User can delete answer', %q{
  As an authorized user
  I'd like to be able to delete my own answer
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user)}

  scenario 'Author of answer delete it', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Delete', match: :first

    expect(page).to have_content 'Question was successfully deleted.'
  end

  scenario 'Not creator of answer tries to delete it' do
    sign_in(user2)
    visit question_path(question)

    expect(page).to have_no_content 'Delete'
  end
end
