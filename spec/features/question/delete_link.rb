require "rails_helper"

feature 'User can delete link', %q{
  As an authorized user
  I'd like to be able to delete my own link
} do

  given!(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/Pavlooid/ab4a73b2742176ef81f783a3f2dd1d94' }

  scenario 'Author of link delete it', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Ruby'
    fill_in 'Body', with: 'Code'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'
    click_on 'Delete link'

    expect(page).to_not have_content 'My gist'
  end
end
