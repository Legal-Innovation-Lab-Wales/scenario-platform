# spec/requests/quizzes/index_spec.rb
require 'rails_helper'

RSpec.describe 'index quizzes (GET quizzes)', type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:alt_admin) { create(:user, :alt_admin) }
  let!(:quizzes) { create_list(:quiz, 10, user: admin) }
  let!(:alt_quizzes) { create_list(:quiz, 10, user: alt_admin) }
  let(:quiz_id) { quizzes.first.id }

  let(:headers) { { 'ACCEPT' => 'application/json' } }

  context 'when user not signed in' do
    before { get '/quizzes', headers: headers }

    it 'returns status code 401 Unauthorized' do
      expect(response).to have_http_status(401)
    end

    it 'returns an unauthorised message' do
      expect(response.body).to include('You need to sign in or sign up before continuing.')
    end
  end

  context 'when any user signed in' do
    before { sign_in user }
    before { get '/quizzes', headers: headers }

    it 'returns http status success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns json content' do
      expect(response.content_type).to include('application/json')
    end

    it 'returns 10 quizzes' do
      expect(Quiz.all.count).to eq(20)
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'expects quizzes to be from the correct organisation' do
      quizzes = JSON.parse(response.body)
      quizzes_user_ids = quizzes.map { |q| q['user_id'] }
      quizzes_user_org_ids = quizzes_user_ids.map { |user_id| User.find(user_id).organisation_id }
      expect(quizzes_user_org_ids.uniq).to eq([user.organisation_id])
    end

    it 'expects quizzes to be available' do
      quizzes = JSON.parse(response.body)
      available_map = quizzes.map { |q| q['available'] }
      expect(available_map).to all(be_truthy)
    end

    context 'when some quizzes are not available' do
      let!(:unavailable_quizzes) { create_list(:quiz, 10, :unavailable) }
      before { get '/quizzes', headers: headers }

      it 'returns http status success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns json content' do
        expect(response.content_type).to include('application/json')
      end

      it 'returns 10 quizzes' do
        expect(Quiz.all.count).to eq(30)
        expect(json.size).to eq(10)
      end

      it 'expects all returned quizzes to be available' do
        quizzes = JSON.parse(response.body)
        available_map = quizzes.map { |q| q['available'] }
        expect(available_map).to all(be_truthy)
      end
    end
  end

  context 'when admin signed in and quizzes not available' do
    before { sign_in admin }
    let!(:quizzes) { create_list(:quiz, 10, :unavailable) }
    before { get '/quizzes', headers: headers }

    it 'returns http status success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns json content' do
      expect(response.content_type).to include('application/json')
    end

    it 'returns quizzes' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'expects quizzes to be not available' do
      quizzes = JSON.parse(response.body)
      available_quizzes = quizzes.map { |q| q['available'] }
      expect(available_quizzes).to all(be_falsey)
    end
  end

end
