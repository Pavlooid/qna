require "rails_helper"

feature "User can see questions", %q{
  In order to find usefull question
  User can see list of all questions
} do

  given!(:questions) { create_list(:question, 3, :with_answers) }

  background { visit questions_path }

  scenario 'User tries to see list of all questions' do
    expect(page).to have_content 'All questions'
  end
end
