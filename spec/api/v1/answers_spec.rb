require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token)}
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }
      let!(:answers) { create_list(:answer, 2, question: question) }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it_behaves_like 'providable fields' do
        let(:all_fields)     { %w[id body created_at updated_at] }
        let(:object)          { answer }
        let(:object_response) { answer_response }
      end

      it 'contains author object' do
        expect(answer_response['author']['id']).to eq answer.author.id
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let!(:user) { create(:user) }
    let(:answer_response) { json['answer'] }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let!(:answer) { create(:answer_with_file, author: user) }
    let!(:links) { create_list(:link, 2,  linkable: answer) }
    let!(:comments) { create_list(:comment, 2,  commentable: answer, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token)}

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it_behaves_like 'providable fields' do
        let(:all_fields)     { %w[id body author created_at updated_at links comments] }
        let(:object)          { answer }
        let(:object_response) { json['answer'] }
      end

      it 'returns list of links' do
        expect(json['answer']['links'].size).to eq 2
      end

      it 'returns list of comments' do
        expect(json['answer']['comments'].size).to eq 2
      end

      it 'contains file link' do
        expect(json['answer']['files'].first).to eq Rails.application.routes.url_helpers.rails_blob_path(answer.files.first, only_path: true)
      end
    end
  end

  describe 'POST /api/v1/questions/question_id/answers' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid attributes' do
        before do
          post api_path, params: { answer: { body: 'body', question: question, author: user }, access_token: access_token.token }, headers: headers
        end

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'contains user object with answer attr' do
          expect(json['answer']['body']).to eq 'body'
          expect(json['answer']['author']['id']).to eq access_token.resource_owner_id
        end
      end

      context 'with invalid attributes' do
        before do 
          post api_path, params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token }, headers: headers
        end

        it 'returns 422 status and errors' do
          expect(response.status).to eq 422
          expect(json['errors']).to be
        end
      end
    end
  end
end
