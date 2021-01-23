# spec/requests/questions_request_spec.rb
require 'rails_helper'

RSpec.describe 'Questions', type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:quiz) { create(:quiz) }
  let!(:questions) { create_list(:question, 10, quiz: quiz) }
  let(:question_id) { questions.first.id }
  let(:quiz_id) { quiz.id }
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:valid_attributes) do
    { question: { order: (Question.last.order + 1),
                  description: 'Setting the scene',
                  text: 'asking the question' } }
  end

  context 'when user not signed in' do
    # Index when unauthorised
    context 'get /quizzes/:quiz_id/questions' do
      before { get "/quizzes/#{quiz_id}/questions", headers: headers }

      it 'returns status code 403' do
        expect(response).to have_http_status(401)
      end

      it 'returns an unauthorised message' do
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
    end
  end

  context 'when any user signed in' do
    before { sign_in user }

    # Index
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

    # Show
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

    # Create when unauthorised
    context 'POST /quizzes/:quiz_id/questions' do
      context 'when the request is valid but the user is not admin' do
        before { post "/quizzes/#{quiz_id}/questions", params: valid_attributes, headers: headers }

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end

        it 'does not create a question' do
          expect(Question.last.text).to_not eq('unauthorized user')
        end
      end
    end
  end

  context 'when admin signed in' do
    before { sign_in admin }

    # Create
    context 'POST /quizzes/:quiz_id/questions' do
      context 'when the request is valid' do
        before { post "/quizzes/#{quiz_id}/questions", params: valid_attributes, headers: headers }

        it 'creates a question' do
          expect(json['text']).to eq('asking the question')
        end

        it 'has the correct quiz id' do
          expect(Question.last.quiz_id).to eq(quiz_id)
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'when no body in request' do
        before { post "/quizzes/#{quiz_id}/questions", params: {}, headers: headers }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a failure message' do
          expect(response.body).to include('param is missing')
        end
      end

      context 'when record is not unique' do
        let(:invalid_attributes) { { question: { order: Question.first.order } } }

        before { post "/quizzes/#{quiz_id}/questions", params: invalid_attributes, headers: headers }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a failure message' do
          expect(response.body).to include('unique')
        end
      end
    end

    # Update
    context 'PUT /quizzes/:quiz_id/questions/:id' do
      let(:valid_attributes) { { question: { text: 'updated text' } } }

      before { put "/quizzes/#{quiz_id}/questions/#{question_id}", params: valid_attributes, headers: headers }

      context 'when question exists' do
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end

        it 'updates the question' do
          updated_question = Question.find(question_id)
          expect(updated_question.text).to match(/updated text/)
        end
      end

      context 'when the question does not exist' do
        let(:question_id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Question/)
        end
      end
    end

    # Delete
    context 'DELETE /quizzes/:quiz_id/questions/:id' do
      before { delete "/quizzes/#{quiz_id}/questions/#{question_id}" }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'deletes the record' do
        expect { Question.find(question_id) }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
