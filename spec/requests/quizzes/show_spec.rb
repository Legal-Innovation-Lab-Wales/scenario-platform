# spec/requests/quizzes/show_spec.rb
require 'rails_helper'

RSpec.describe 'show quiz (GET quiz)', type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let!(:quiz) { create(:quiz, user: admin) }
  let(:quiz_id) { quiz.id }
  let!(:questions) { create_list(:question, 10, quiz: quiz) }

  let(:headers) { { 'ACCEPT' => 'application/json' } }

  context 'when user not signed in' do

    before { get "/quizzes/#{quiz_id}", headers: headers }

    it 'returns status code 401 Unauthorized' do
      expect(response).to have_http_status(401)
    end

    it 'returns an unauthorised message' do
      expect(response.body).to include('You need to sign in or sign up before continuing.')
    end
  end

  context 'when any user signed in' do
    before { sign_in user }
    before { get "/quizzes/#{quiz_id}", headers: headers }

    context 'when the record exits' do

      it 'returns the quiz' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(quiz_id)
      end

      it 'doesnt include questions with the quiz' do
        expect(json['questions']).to be_nil
      end

      it 'returns http status success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns json content' do
        expect(response.content_type).to include('application/json')
      end

      it 'expects the quiz to be available' do
        expect(json['available']).to be_truthy
      end

      it 'expects the quiz to be from the correct organisation' do
        expect(User.find(json['user_id']).organisation_id).to eq(user.organisation_id)
      end

    end

    context 'when the record does not exist' do
      let(:quiz_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to include('Couldn\'t find Quiz')
      end
    end

    context 'when the quiz is not available' do
      let(:unavailable_quiz) { create(:quiz, :unavailable) }

      before { get "/quizzes/#{unavailable_quiz.id}", headers: headers }

      it 'returns http status not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns json content' do
        expect(response.content_type).to include('application/json')
      end

      it 'does not return the quiz' do
        expect(Quiz.find(unavailable_quiz.id)).to be_present
        expect(response.body).to include('Couldn\'t find Quiz')
      end
    end
  end

  context 'when admin signed in and quiz is not available' do
    before { sign_in admin }
    let(:unavailable_quiz) { create(:quiz, :unavailable) }
    let!(:questions) { create_list(:question, 10, quiz: unavailable_quiz) }
    before { get "/quizzes/#{unavailable_quiz.id}", headers: headers }

    it 'returns the quiz' do
      expect(Quiz.find(unavailable_quiz.id)).to be_present
      expect(json).not_to be_empty
      expect(json['id']).to eq(unavailable_quiz.id)
    end

    it 'includes questions with the quiz' do
      expect(json['questions']).not_to be_empty
      expect(json['questions'].size).to eq(10)
    end

    it 'returns http status success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns json content' do
      expect(response.content_type).to include('application/json')
    end

    it 'expects the quiz to be not available' do
      expect(json['available']).to be_falsey
    end
  end
end