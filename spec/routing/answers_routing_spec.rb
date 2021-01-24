# spec/routing/answers_routing_spec.rb
require 'rails_helper'

RSpec.describe AnswersController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/quizzes/1/questions/1/answers/new').to route_to('answers#new', quiz_id: '1', question_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/quizzes/1/questions/1/answers/1/edit').to route_to('answers#edit', quiz_id: '1', question_id: '1', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/quizzes/1/questions/1/answers/').to route_to('answers#create', quiz_id: '1', question_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/quizzes/1/questions/1/answers/1').to route_to('answers#update', quiz_id: '1', question_id: '1', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/quizzes/1/questions/1/answers/1').to route_to('answers#destroy', quiz_id: '1', question_id: '1', id: '1')
    end
  end
end
