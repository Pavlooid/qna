require "rails_helper"

feature 'User can add links to answer', %q{
  In order to provide additional info to answer
  As an answer's author
  I'd like to be able to add links
} do
  
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/Pavlooid/ab4a73b2742176ef81f783a3f2dd1d94' }
  given(:url) { 'https://developer.mozilla.org/ru/docs/Web/HTTP/CORS/Errors/CORSMissingAllowOrigin?utm_source=devtools&utm_medium=firefox-cors-errors&utm_campaign=default' }
  given(:fake_url) { 'Uncorrect link'}

  describe 'User adds' do
    background do
      sign_in(user)
      visit question_path(question)

      fill_in 'Body', with: 'Answer'
    end

    scenario 'link when answer', js: true do
      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: url

      click_on 'Answer'

      expect(page).to have_link 'My link', href: url
    end

    scenario 'gist link when answer', js: true do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Answer'

      expect(page).to have_link gist_url
    end

    scenario 'incorrect link when answer', js: true do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: fake_url

      click_on 'Answer'

      expect(page).to have_content 'Links url is invalid'
    end
  end
end
