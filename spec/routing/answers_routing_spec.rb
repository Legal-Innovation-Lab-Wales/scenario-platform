# spec/routing/answers_routing_spec.rb
require 'rails_helper'

RSpec.describe AnswersController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/scenarios/1/questions/1/answers/new').to route_to('answers#new', scenario_id: '1', question_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/scenarios/1/questions/1/answers/1/edit').to route_to('answers#edit', scenario_id: '1', question_id: '1', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/scenarios/1/questions/1/answers/').to route_to('answers#create', scenario_id: '1', question_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/scenarios/1/questions/1/answers/1').to route_to('answers#update', scenario_id: '1', question_id: '1', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/scenarios/1/questions/1/answers/1').to route_to('answers#destroy', scenario_id: '1', question_id: '1', id: '1')
    end
  end
end
