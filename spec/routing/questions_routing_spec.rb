# spec/routing/questions_routing_spec.rb
require 'rails_helper'

RSpec.describe QuestionsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/scenarios/1/questions/1').to route_to('questions#show', scenario_id: '1', id: '1')
    end

    it 'routes to #new' do
      expect(get: '/scenarios/1/questions/new').to route_to('questions#new', scenario_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/scenarios/1/questions/1/edit').to route_to('questions#edit', scenario_id: '1', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/scenarios/1/questions/').to route_to('questions#create', scenario_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/scenarios/1/questions/1').to route_to('questions#update', scenario_id: '1', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/scenarios/1/questions/1').to route_to('questions#destroy', scenario_id: '1', id: '1')
    end
  end
end
