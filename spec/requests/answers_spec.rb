# spec/requests/answers_spec.rb
require 'rails_helper'

RSpec.describe 'Answers', type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:quiz) { create(:quiz) }
  let(:quiz_id) { quiz.id }
  let(:questions) { create_list(:question, 5, quiz: quiz) }
  let(:question) { questions.first }
  let(:question_id) { question.id }
  let(:answer) { create(:answer, :with_next_question_order) }
  let(:answer_id) { answer.id }

  let(:headers) { { 'ACCEPT' => 'application/json' } }

  let(:valid_attributes) do
    { answer: { text: 'answering the question this way',
                variable_mods: { 'health' => 10, 'stamina' => 10, 'experience' => 10, 'coin' => 10 },
                next_question_order: questions.second.order } }
  end

  describe 'create answer (POST quiz_question_answers)' do
    context 'when no user signed in' do
      before { post quiz_question_answers_url(quiz, question), params: valid_attributes, headers: headers }

      it 'returns status code 401 Unauthorized' do
        expect(response).to have_http_status(401)
      end

      it 'returns an unauthorised message' do
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
    end

    context 'when user signed in but not admin' do
      before { sign_in user }
      before { post quiz_question_answers_url(quiz, question), params: valid_attributes, headers: headers }

      it 'returns status code 403 Forbidden' do
        expect(response).to have_http_status(403)
      end

      it 'does not create a answer' do
        expect(Answer.count).to be(0)
      end
    end

    context 'when admin signed in' do
      before { sign_in admin }
      context 'when the request is valid' do
        before { post quiz_question_answers_url(quiz, question), params: valid_attributes, headers: headers }

        it 'creates a answer' do
          expect(json['text']).to eq('answering the question this way')
        end

        it 'has the correct question id' do
          expect(Answer.last.question_id).to eq(question_id)
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

        it 'has the valid variable mods' do
          expect(json['variable_mods']).to include('health')

        end

        context 'when not all variable_mods are passed' do
          let(:valid_attributes) do
            { answer: { text: 'answering the question this second way',
                        variable_mods: { 'health' => 10, 'stamina' => 10 },
                        next_question_order: questions.second.order } }
          end

          it 'creates a answer' do
            expect(json['text']).to eq('answering the question this second way')
          end

          it 'has valid variable mods' do
            expect(json['variable_mods']).to include('health', 'stamina')
            expect(json['variable_mods']).not_to include('coin')
          end

          it 'returns status code 201' do
            expect(response).to have_http_status(201)
          end

          context 'when no variable_mods are passed' do
            let(:valid_attributes) do
              { answer: { text: 'answering the question this third way',
                          next_question_order: questions.second.order } }
            end

            it 'creates a answer' do
              expect(json['text']).to eq('answering the question this third way')
            end

            it 'has no variable mods' do
              expect(json['variable_mods']).to be_nil
            end

            it 'returns status code 201' do
              expect(response).to have_http_status(201)
            end
          end
        end
      end

      context 'when no body in request' do
        before { post quiz_question_answers_url(quiz, question), params: {}, headers: headers }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a failure message' do
          expect(response.body).to include('param is missing')
        end
      end

      context 'when record is missing an attribute ' do
        let(:invalid_attributes) { { answer: { next_question_order: Question.first.order } } }

        before { post quiz_question_answers_url(quiz, question), params: invalid_attributes, headers: headers }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a failure message' do
          expect(response.body).to include('Validation failed:')
        end
      end

      context 'when an incorrect next_question_order is submitted' do
        let(:invalid_attributes) { { answer: { text: 'updated text', next_question_order: (Question.last.order + 5) } } }

        before { post quiz_question_answers_url(quiz, question), params: invalid_attributes, headers: headers }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a failure message' do
          expect(response.body).to include('Couldn\'t find Question')
        end
      end

      context 'when invalid variable_mods are submitted' do
        let(:invalid_attributes) do
          { answer: { text: 'this is a bad question',
                      variable_mods: { 'health' => 10, 'stamina' => 10, 'bad' => 10 },
                      next_question_order: questions.second.order } }
        end
        before { post quiz_question_answers_url(quiz, question), params: invalid_attributes, headers: headers }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a failure message' do
          expect(response.body).to include('Validation failed:')
          expect(response.body).to include('bad')
        end

      end
    end
  end

  describe 'update answer (PUT quiz_question_answer)' do

    context 'when admin signed in' do
      before { sign_in admin }

      let(:updated_attributes) { { answer: { text: 'updated text', variable_mods: { 'health' => 69,  'stamina' => 10, 'experience' => 10, 'coin' => 10 } } } }
      # before { puts("question_id: #{question_id}. Quiz questions #{Quiz.find(quiz_id).questions.map {|q| [q.id, q.order]}}")}
      before { put "/quizzes/#{quiz_id}/questions/#{question_id}/answers/#{answer_id}", params: updated_attributes, headers: headers }

      context 'when answer exists' do
        let(:updated_answer) { Answer.find(answer_id) }

        it 'returns status code 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'updates the answer text' do
          expect(updated_answer.text).to eq('updated text')
        end

        it 'updates the variable_mods' do
          expect(json['variable_mods']['health']).to eq('69')
          expect(updated_answer.variable_mods['health']).to eq('69')
        end

        it 'doesnt update other variable_mods' do
          expect(json['variable_mods']['coin']).to eq('10')
          expect(updated_answer.variable_mods['coin']).to eq('10')
        end

        context 'when updating the next question order' do
          let(:answer_original_next_question_id) { answer.next_question_id }
          let(:updated_attributes) { { answer: { next_question_order: questions.last.order } } }
          before { put quiz_question_answer_url(quiz, question, answer), params: updated_attributes, headers: headers }

          it 'should change the next question ID' do
            expect(Answer.find(answer_id).next_question_id).to eq(questions.last.id)
            expect(Answer.find(answer_id).next_question_id).not_to eq(answer_original_next_question_id)
          end

        end
      end

      context 'when the answer does not exist' do
        let(:answer_id) { 0 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Answer/)
        end
      end
    end
  end

  describe 'delete answer (DELETE quiz_question_answer' do
    context 'when admin signed in' do
      before { sign_in admin }
      before { delete "/quizzes/#{quiz_id}/questions/#{question_id}/answers/#{answer_id}", headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'deletes the record' do
        expect { Answer.find(answer_id) }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
