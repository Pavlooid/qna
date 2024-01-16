require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'POST #create' do
    before { login(user) }

    it 'save comment to question' do
      post :create, params: { body: 'sup', commentable: question}, format: :js
      expect(page).to have_content 'sup'
    end

    it "doesn't save comment to question" do
      post :create, params: { body: '', commentable: question}, format: :js
      expect(page).to_not have_content 'sup'
    end
  end
end
