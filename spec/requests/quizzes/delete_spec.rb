# spec/requests/quizzes/delete_spec.rb
require 'rails_helper'

RSpec.describe 'delete quiz (DELETE quiz)', type: :request do
  let(:admin) { create(:user, :admin) }
  let!(:quiz) { create(:quiz, user: admin) }
  let(:quiz_id) { quiz.id }

  let(:headers) { { 'ACCEPT' => 'application/json' } }

  context 'when admin signed in' do
    before { sign_in admin }
    before { delete "/quizzes/#{quiz_id}", headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'deletes the record' do
      expect { Quiz.find(quiz_id) }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
