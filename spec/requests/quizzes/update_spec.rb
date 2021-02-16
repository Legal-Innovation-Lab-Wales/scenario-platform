# spec/requests/quizzes/update_spec.rb
require 'rails_helper'

RSpec.describe 'update quiz (PUT quiz)', type: :request do
  let(:admin) { create(:user, :admin) }
  let!(:quiz) { create(:quiz, user: admin) }
  let(:quiz_id) { quiz.id }

  let(:headers) { { 'ACCEPT' => 'application/json' } }

  context 'when admin signed in' do
    before { sign_in admin }
    let(:valid_attributes) { { quiz: { name: 'updated name' } } }
    before { put "/quizzes/#{quiz_id}", params: valid_attributes, headers: headers }

    context 'when quiz exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the quiz' do
        updated_quiz = Quiz.find(quiz_id)
        expect(updated_quiz.name).to match(/updated name/)
      end
    end

    context 'when the quiz does not exist' do
      let(:quiz_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Quiz/)
      end
    end
  end
end
