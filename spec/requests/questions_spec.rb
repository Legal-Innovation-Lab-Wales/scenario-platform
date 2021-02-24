# spec/requests/questions_spec.rb
require 'rails_helper'

RSpec.describe 'Questions', type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:scenarios) { create_list(:scenario, 2) }
  let(:scenario_id) { scenarios.first.id }
  let!(:questions) { create_list(:question, 10, scenario: scenarios.first) }
  let!(:scenario_2_questions) { create_list(:question, 10, scenario: scenarios.second) }
  let(:question_id) { questions.first.id }
  let!(:answers) { create_list(:answer, 10, question: questions.first) }

  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'index questions (GET scenario_questions)' do
    context 'when user not signed in' do
      before { get "/scenarios/#{scenario_id}/questions", headers: headers }

      it 'returns status code 401 Unauthorized' do
        expect(response).to have_http_status(401)
      end

      it 'returns an unauthorised message' do
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
    end

    context 'when any user signed in' do
      before { sign_in admin }
      before { get "/scenarios/#{scenario_id}/questions", headers: headers }

      it 'returns http status success' do
        expect(response).to have_http_status(:success)
        expect(response).to be_successful
      end

      it 'returns json content' do
        expect(response.content_type).to include('application/json')
      end

      it 'returns questions' do
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'includes answers with the questions' do
        expect(json.first['answers']).not_to be_empty
        expect(json.first['answers'].size).to eq(10)
      end

      it 'expects questions to be for the right scenario' do
        questions = JSON.parse(response.body)
        question_scenario_ids = questions.map { |q| q['scenario_id'] }
        expect(question_scenario_ids.uniq).to eq([scenario_id])
      end

      context 'when scenario does not exist' do
        let(:scenario_id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to include('Couldn\'t find Scenario')
        end

      end
    end
  end

  describe 'show question (GET scenario_question)' do
    context 'when user not signed in' do
      before { get "/scenarios/#{scenario_id}/questions/#{question_id}", headers: headers }

      it 'returns status code 401 Unauthorized' do
        expect(response).to have_http_status(401)
      end

      it 'returns an unauthorised message' do
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
    end

  end

  describe 'create question (POST scenario_questions)' do
    let(:valid_attributes) do
      { question: { order: (Question.last.order + 1),
                    description: 'Setting the scene',
                    text: 'asking the question' } }
    end

    context 'when user not signed in' do
      before { post "/scenarios/#{scenario_id}/questions", params: valid_attributes, headers: headers }

      it 'returns status code 401 Unauthorized' do
        expect(response).to have_http_status(401)
      end

      it 'returns an unauthorised message' do
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
    end

    context 'when user signed in but not admin' do
      before { sign_in user }
      before { post "/scenarios/#{scenario_id}/questions", params: valid_attributes, headers: headers }

      it 'returns status code 403 Forbidden' do
        expect(response).to have_http_status(403)
      end

      it 'does not create a question' do
        expect(Question.last.text).to_not eq('unauthorized user')
      end
    end

    context 'when admin signed in' do
      before { sign_in admin }

      context 'when the request is valid' do
        before { post "/scenarios/#{scenario_id}/questions", params: valid_attributes, headers: headers }

        it 'creates a question' do
          expect(json['text']).to eq('asking the question')
        end

        it 'has the correct scenario id' do
          expect(Question.last.scenario_id).to eq(scenario_id)
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'when no body in request' do
        before { post "/scenarios/#{scenario_id}/questions", params: {}, headers: headers }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a failure message' do
          expect(response.body).to include('param is missing')
        end
      end

      context 'when record is not unique' do
        let(:invalid_attributes) { { question: { order: Question.first.order } } }
        before { post "/scenarios/#{scenario_id}/questions", params: invalid_attributes, headers: headers }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a failure message' do
          expect(response.body).to include('unique')
        end
      end
    end
  end

  describe 'update question (PUT scenario_questions)' do
    context 'when admin signed in' do
      before { sign_in admin }
      let(:valid_attributes) { { question: { text: 'updated text' } } }
      before { put "/scenarios/#{scenario_id}/questions/#{question_id}", params: valid_attributes, headers: headers }

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
  end

  describe 'delete question (DELETE scenario_questions)' do
    context 'when admin signed in' do
      before { sign_in admin }
      before { delete "/scenarios/#{scenario_id}/questions/#{question_id}", headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'deletes the record' do
        expect { Question.find(question_id) }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
