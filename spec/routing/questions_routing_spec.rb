# spec/routing/questions_routing_spec.rb
require 'rails_helper'

RSpec.describe QuestionsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/quizzes/1/questions/1').to route_to('questions#show', quiz_id: '1', id: '1')
    end

    it 'routes to #new' do
      expect(get: '/quizzes/1/questions/new').to route_to('questions#new', quiz_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/quizzes/1/questions/1/edit').to route_to('questions#edit', quiz_id: '1', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/quizzes/1/questions/').to route_to('questions#create', quiz_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/quizzes/1/questions/1').to route_to('questions#update', quiz_id: '1', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/quizzes/1/questions/1').to route_to('questions#destroy', quiz_id: '1', id: '1')
    end
  end
end
