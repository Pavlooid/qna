require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let(:question) { create(:question, :with_answers) }
  let(:answers) { question.answers }
  let(:answer) { answers.sample }

  describe 'GET #index' do
    before { get :index, params: { question_id: question, id: answer } }

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:answer) { answers.sample }

    before { get :show, params: { question_id: question, id: answer.id } }

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { question_id: question.id, id: answer.id } }

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    let!(:question) { create(:question, :with_answers) }

    before { login(user) }

    context 'valid' do
      let(:answer_params) { { answer: attributes_for(:answer, author_id: user.id), question_id: question, user_id: user.id } }
      
      it 'save new answer in db' do
        expect { post :create, params: answer_params }.to change(Answer, :count).by(1) 
      end
      it 'redirects to show view' do
        post :create, params: answer_params
        expect(response).to redirect_to(question_path(question))
      end
    end

    context 'invalid' do
      it 'no save' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end
      it 're-render new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'valid' do
      it 'answer to @answer' do
        patch :update, params: { id: answer.id, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq(answer)
      end

      it 'update answer' do
        patch :update, params: { id: answer.id, answer: { body: 'Answer' } }
        answer.reload

        expect(answer.body).to eq 'Answer'
      end

      it 'redirect to answer' do
        patch :update, params: { id: answer.id, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'invalid' do
      before { patch :update, params: { id: answer.id, answer: attributes_for(:answer, :invalid) } }
      it 'no change' do
        answer.reload

        expect(answer.body).to eq 'MyString'
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    
    let!(:question) { create(:question, :with_answers) }

    it 'delete answer' do
      expect { delete :destroy, params: { id: question.answers.first.id } }.to change(Answer, :count).by(-1)
    end

    it 'redirect to question' do
      delete :destroy, params: { id: question.answers.first.id }
      expect(response).to redirect_to question
    end
  end
end
