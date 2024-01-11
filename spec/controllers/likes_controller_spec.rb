require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'POST #like' do
    before { login(user1) }

    it 'change question rating by +1' do
      expect { post :like, params: { liked_type: 'question', id: question.id, liked_params: { rating: +1, user_id: user1.id } }, format: :json }.to change(question.likes, :count).by(1) 
    end
  end
end
