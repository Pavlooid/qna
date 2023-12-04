require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answers) { question.answers }
  let(:answer) { create(:answer) }

  describe 'GET #index' do
    let(:answer) { answers.sample }

    before { get :index, params: { question_id: question, id: answer } }

    it 'show all answers of question' do
      expect(assigns(:asnwers)).to eq answer
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { question_id: question, id: answer.id } }
    
    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question, id: answer.id } }

    it 'new Answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { question_id: question, id: answer.id } }

    it 'answer to @answer' do
      expect(assigns(:answer)).to eq(answer)
    end

    it 'render new edit' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'valid' do
      it 'save new answer in db' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:answer)
      end
    end

    context 'invalid' do
      it 'no save' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end
      it 're-render new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'valid' do
      it 'answer to @answer' do
        patch :update, params: { id: answer.id, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq(answer)
      end

      it 'update answer' do
        patch :update, params: { id: answer.id, answer: { body: 'Answer', correct: true } }
        answer.reload

        expect(answer.body).to eq 'Answer'
        expect(answer.correct).to eq true
      end

      it 'redirect to answer' do
        patch :update, params: { id: answer.id, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer
      end
    end

    context 'invalid' do
      before { patch :update, params: { id: answer.id, answer: attributes_for(:answer, :invalid) } }
      it 'no change' do
        answer.reload

        expect(answer.body).to eq 'MyString'
        expect(answer.correct).to eq true
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
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
