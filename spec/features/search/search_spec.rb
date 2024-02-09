require "rails_helper"

feature 'User can search for intresting information', %q{
  In order to find needed info
  As a user
  I'd like to be able to use search
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'User searchs question', sphinx: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in 'query', with: 'MyString'
        check 'search_model_question'

        click_on 'Search'
      end

      expect(page).to have_content 'MyString'
    end
  end

  scenario 'User searchs answer', sphinx: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in 'query', with: 'MyString'
        check 'search_model_answer'

        click_on 'Search'
      end

      expect(page).to have_content 'MyString'
    end
  end

  scenario 'User searchs user', sphinx: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in 'query', with: 'user'
        check 'search_model_user'

        click_on 'Search'
      end

      expect(page).to have_content 'user'
    end
  end

  scenario 'User searchs comment', sphinx: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in 'query', with: 'Commentatio'
        check 'search_model_comment'

        click_on 'Search'
      end

      expect(page).to have_content 'Commentatio'
    end
  end
end
