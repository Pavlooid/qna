require "rails_helper"

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT-TYPE" => "application/json",
                    "ACCEPT" => 'application/json'} }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
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
    # создать вопроса
  end

  describe 'PATCH /api/v1/questions/:id' do
    # обновление вопроса
  end

  describe 'DELETE /api/v1/questions/:id' do
    # удаление вопроса
  end
end
