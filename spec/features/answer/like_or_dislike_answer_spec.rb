require "rails_helper"

feature 'User can like or dislike answer', %q{
  As an authorized user
  In order to like or dislike answer to question
  User can like or dislike answer
  User can't vote for his own answer
  User can vote only one time per answer
  User can change his mind and re-vote
  Any user can see rating
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, author: user2) }
  given!(:answer) { create(:answer, author: user2, question: question) }

  scenario 'Authorized user vote for answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Like', match: :first
  end

  scenario 'Authorized user can not vote for his own answer', js: true do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_button 'Like'
  end
end
