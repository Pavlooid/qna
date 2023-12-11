require "rails_helper"

feature "User can see answers", %q{
  In order to see answers of question
  I'd like to be able to see all answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, :with_answers, author: user) }

  scenario 'User tries to see answers of question' do
    sign_in(user)
    visit question_path(question)

    answer = question.answers.first

    expect(page).to have_content answer.body
  end
end
