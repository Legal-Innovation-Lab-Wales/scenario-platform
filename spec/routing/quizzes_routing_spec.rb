# spec/routing/quizzes_routing_spec.rb
require 'rails_helper'

RSpec.describe QuizzesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/quizzes').to route_to('quizzes#index')
    end

    it 'routes to #show' do
      expect(get: '/quizzes/1').to route_to('quizzes#show', id: '1')
    end

    it 'routes to #new' do
      expect(get: '/quizzes/new').to route_to('quizzes#new')
    end

    it 'routes to #edit' do
      expect(get: '/quizzes/1/edit').to route_to('quizzes#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/quizzes').to route_to('quizzes#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/quizzes/1').to route_to('quizzes#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/quizzes/1').to route_to('quizzes#destroy', id: '1')
    end
  end
end
