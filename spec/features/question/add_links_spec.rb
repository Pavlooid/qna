require "rails_helper"

feature 'User can add links to question', %q{
  In order to provide additional info to question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/Pavlooid/ab4a73b2742176ef81f783a3f2dd1d94' }

  scenario 'User adds link when ask question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Ruby'
    fill_in 'Body', with: 'Code'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end

end
