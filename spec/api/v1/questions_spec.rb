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
        get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers
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
    # отдельный вопрос
  end

  describe 'POST /api/v1/questions' do
    # создать вопроса
  end

  describe 'PATCH /api/v1/questions/:id' do
    # обновление вопроса
  end

  describe 'DELETE /api/v1/questions/:id' do
    # создать вопроса
  end
end
