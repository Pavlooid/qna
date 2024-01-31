require "rails_helper"

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:questions) { create_list(:question, 2) }
      let!(:answers) { create_list(:answer, 3, question: question)}

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it_behaves_like 'providable fields' do
        let(:all_fields) { %w[id title body created_at updated_at] }
        let(:object) { question }
        let(:object_response) { question_response}
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body author_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question_with_file, author: user) }
    let!(:links) { create_list(:link, 2, linkable: question) }
    let!(:comments) { create_list(:comment, 2, commentable: question, user: user) }
    let(:question_response) { json['question'] }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it_behaves_like 'providable fields' do
        let(:all_fields) { %w[id title body created_at updated_at links comments] }
        let(:object) { question }
        let(:object_response) { question_response }
      end

      it 'returns list of links' do
        expect(json['question']['links'].size).to eq 2
      end

      it 'returns list of comments' do
        expect(json['question']['comments'].size).to eq 2
      end

      it 'returns file link' do
        expect(json['question']['files'].first).to eq Rails.application.routes.url_helpers.rails_blob_path(question.files.first, only_path: true)
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'valid' do
        before do 
          post api_path, params: { question: { title: 'test', body: 'test'}, access_token: access_token.token }, headers: headers
        end

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'contains user object with question attrs' do
          expect(json['question']['body']).to eq 'test'
          expect(json['question']['title']).to eq 'test'
          expect(json['question']['author']['id']).to eq access_token.resource_owner_id
        end
      end

      context 'invalid' do
        before { post api_path, params: { question: { title: '', body: ''}, access_token: access_token.token }, headers: headers }

        it 'returns 422 status and errors' do
          expect(response.status).to eq 422
          expect(json['errors']).to be
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let!(:user)       { create(:user)}
    let!(:question)   { create(:question, author: user) }
    let(:api_path)   { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token, resource_owner_id: user.id )}

      context 'with valid attributes' do
        before do
          patch api_path, params: { question: { title: 'title', body: 'body' }, access_token: access_token.token }, headers: headers
        end

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'contains user object with json attr' do
          expect(json['question']['title']).to eq 'title'
          expect(json['question']['body']).to eq 'body'
          expect(json['question']['author']['id']).to eq question.author.id
        end
      end

      context 'with invalid attributes' do
        before do
          patch api_path, params: {question: { title: '', body: '' }, access_token: access_token.token }, headers: headers
        end

        it 'returns 422 status and errors' do
          expect(response.status).to eq 422
          expect(json['errors']).to be
        end
      end

      context 'authorized another user' do
        let(:another_user)      { create(:user)}
        let(:another_question)  { create(:question, author: another_user) }
        let(:another_api_path)  { "/api/v1/questions/#{another_question.id}" }
        let(:another_title) { another_question.title}
        let(:another_body)  { another_question.body}

        before do 
          patch another_api_path, params: { question: { title: 'title', body: 'body' }, access_token: access_token.token }, headers: headers
        end

        it 'does not update a question' do
          another_question.reload

          expect(another_question.title).to eq another_title
          expect(another_question.body).to eq another_body
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:user)       { create(:user)}
    let!(:question)   { create(:question, author: user) }
    let!(:api_path)   { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized author' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it 'deletes the question' do
        expect do
          delete api_path, params: { access_token: access_token.token}, headers: headers
        end.to change(Question, :count).by(-1)
      end

      it 'returns 200 status' do
        delete api_path, params: { access_token: access_token.token}, headers: headers
        expect(response).to be_successful
      end

      it 'returns deleted question json' do
        delete api_path, params: { access_token: access_token.token}, headers: headers
        %w[id title body author created_at updated_at].each do |attr|
          expect(json['question'][attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        delete api_path, params: { access_token: access_token.token}, headers: headers
        expect(json['question']['author']['id']).to eq question.author.id
      end

      context 'authorized with wrong access token' do
        it 'does non deletes the question' do
          expect do
            delete api_path, params: { access_token: '1234'}, headers: headers
          end.to_not change(Question, :count)
        end
      end
    end
  end
end
