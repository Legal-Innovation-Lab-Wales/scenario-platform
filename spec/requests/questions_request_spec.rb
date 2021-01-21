require 'rails_helper'

RSpec.describe 'Questions', type: :request do
  let(:user) { create(:user) }
  let(:quiz) { create(:quiz) }
  let!(:questions) { create_list(:question, 10, quiz: quiz) }
  let(:question_id) { questions.first.id }
  let(:quiz_id) { quiz.id }
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  context 'when user signed in' do
    before { sign_in user }

    context 'GET /quizzes/:quiz_id/questions' do
      before { get "/quizzes/#{quiz_id}/questions", headers: headers }

      it 'returns http status success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns json content' do
        expect(response.content_type).to include('application/json')
      end

      it 'returns questions' do
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end
    end

    context 'GET /quizzes/:quiz_id/questions/:id' do
      before { get "/quizzes/#{quiz_id}/questions/#{question_id}", headers: headers }

      context 'when the record exits' do
        it 'returns the question' do
          expect(json).not_to be_empty
          expect(json['id']).to eq(question_id)
        end
        it 'returns http status success' do
          expect(response).to have_http_status(:success)
        end
        it 'returns json content' do
          expect(response.content_type).to include('application/json')
        end
      end

      context 'when the record does not exist' do
        let(:question_id) { 100 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        # it 'returns a not found message' do
        #   expect(response.body).to match(/Couldn't find Question/)
        # end
      end

    end
  end
end
