require "rails_helper"

feature 'Author of question can choose best answer', %q{
  In order to mark best answer
  Author can choose best answer by clicking on button best
  Only one answer can be mark as best
  Best answer should be at the top
  Author can change best answer
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create_list(:answer, 3, question: question, author: user)}

  scenario 'Author of question can choose best answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Best', match: :first
    expect(page).to have_content('Best answer!')
  end

  scenario 'Not author of question can not choose best answer', js: true do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_content('Best')
  end

  scenario 'Unauthorized user', js: true do
    visit question_path(question)

    expect(page).to_not have_content('Best')
  end
end
