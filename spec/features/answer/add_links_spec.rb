require "rails_helper"

feature 'User can add links to answer', %q{
  In order to provide additional info to answer
  As an answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/Pavlooid/ab4a73b2742176ef81f783a3f2dd1d94' }

  scenario 'User adds link when answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'Answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

end
