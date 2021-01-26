# spec/requests/quizzes_spec.rb
require 'rails_helper'

RSpec.describe 'Quizzes', type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:alt_admin) { create(:user, :alt_admin) }
  let!(:quizzes) { create_list(:quiz, 10, user: admin) }
  let!(:alt_quizzes) { create_list(:quiz, 10, user: alt_admin) }
  let(:quiz_id) { quizzes.first.id }
  let!(:questions) { create_list(:question, 10, quiz: quizzes.first) }

  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'index quizzes (GET quizzes)' do
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
        expect(quizzes_user_ids.map { |user_id| User.find(user_id).organisation_id }.uniq).to eq([user.organisation_id])
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

        it 'returns no quizzes' do
          expect(Quiz.all.count).to eq(30)
          expect(json.size).to eq(10)
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

  describe 'show quiz (GET quiz)' do
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
      before { get "/quizzes/#{unavailable_quiz.id}", headers: headers }

      it 'returns the quiz' do
        expect(Quiz.find(unavailable_quiz.id)).to be_present
        expect(json).not_to be_empty
        expect(json['id']).to eq(unavailable_quiz.id)
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

  describe 'create quiz (POST quizzes)' do
    let(:valid_attributes) do
      { quiz: { name: 'valid quiz name',
                description: 'quiz description',
                variables: %w[health stamina experience coin],
                variable_initial_values: [100, 100, 0, 10],
                available: true } }
    end

    context 'when user not signed in' do
      before { post '/quizzes', params: valid_attributes, headers: headers }

      it 'returns status code 401 Unauthorized' do
        expect(response).to have_http_status(401)
      end

      it 'returns an unauthorised message' do
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
    end

    context 'when user signed in but not admin' do
      before { sign_in user }
      before { post '/quizzes', params: valid_attributes, headers: headers }

      it 'returns status code 403 Forbidden' do
        expect(response).to have_http_status(403)
      end

      it 'does not create a question' do
        expect(Quiz.last.name).to_not eq('valid quiz name')
      end
    end

    context 'when admin signed in' do
      before { sign_in admin }
      context 'when the request is valid' do

        before { post '/quizzes', params: valid_attributes, headers: headers }

        it 'creates a question' do
          expect(json['name']).to eq('valid quiz name')
          expect(json['variables'][0]).to eq('health')
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'when no body in request' do
        before { post '/quizzes', params: {}, headers: headers }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a failure message' do
          expect(response.body).to include('param is missing')
        end
      end
    end
  end

  describe 'update quiz (PUT quiz)' do
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

  describe 'delete quiz (DELETE quiz)' do
    context 'when admin signed in' do
      before { sign_in admin }
      before { delete "/quizzes/#{quiz_id}" }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'deletes the record' do
        expect { Quiz.find(quiz_id) }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

end
