require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'show all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { id: question } }

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'valid' do
      it 'save question in db' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response). to redirect_to questions_path
      end
    end

    context 'invalid' do
      it 'no save' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end
      it 're-render new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'valid' do
      it 'question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end
      it 'change @question' do
        patch :update, params: { id: question, question: { title: 'title', body: 'body' } }
        question.reload

        expect(question.title).to eq 'title'
        expect(question.body).to eq 'body'
      end
      it 'redirect to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response). to redirect_to questions_path
      end
    end

    context 'not valid' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }
      
      it 'no change' do
        question.reload

        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end
      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    
    let!(:question) { create(:question, author: user) }

    it 'delete question' do 
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirect to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end
