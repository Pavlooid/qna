require "rails_helper"

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT-TYPE" => "application/json",
                    "ACCEPT" => 'application/json'} }

  describe 'GET /api/v1/questions/:question_id/answers' do
    # список ответов у вопроса
  end

  describe 'GET /api/v1/answers/:id' do
    # конкретный ответ
  end

  describe 'POST /api/v1/questions/question_id/answers' do
    # создание ответа на вопрос
  end

  describe 'PATCH /api/v1/questions/:id' do
    # обновление ответа у вопроса
  end

  describe 'DELETE /api/v1/answers/:id' do
    # удаление ответа
  end
end
