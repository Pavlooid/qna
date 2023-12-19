require "rails_helper"

feature "User can see questions", %q{
  In order to find usefull question
  I'd like to be able to see all questions
} do

  given!(:questions) { create_list(:question, 3, :with_answers) }

  scenario 'User tries to see all questions' do
    visit questions_path
  end
end
