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
  end

  describe 'GET #show' do
    before { get :show, params: { id: question }, format: :js }

    it 'render show view' do
      expect(response).to render_template :show
    end

    it 'assigns new link for question' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns a new Question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'valid' do
      it 'save question in db' do
        expect { post :create, params: { question: attributes_for(:question) }, format: :js }.to change(Question, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }, format: :js
        expect(response). to redirect_to assigns(:question)
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
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end
      it 'change @question' do
        patch :update, params: { id: question, question: { title: 'title', body: 'body' }, format: :js }
        question.reload

        expect(question.title).to eq 'title'
        expect(question.body).to eq 'body'
      end
      it 'redirect to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to redirect_to question
      end
    end

    context 'not valid' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }
      
      it 'no change' do
        question.reload

        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end
      it 're-render edit view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    
    let!(:question) { create(:question, author: user) }

    it 'delete question' do 
      expect { delete :destroy, params: { id: question }, format: :js }.to change(Question, :count).by(-1)
    end
  end
end
