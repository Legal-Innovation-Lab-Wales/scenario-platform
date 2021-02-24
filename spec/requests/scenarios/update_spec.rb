# spec/requests/scenarios/update_spec.rb
require 'rails_helper'

RSpec.describe 'update scenario (PUT scenario)', type: :request do
  let(:admin) { create(:user, :admin) }
  let!(:scenario) { create(:scenario, user: admin) }
  let(:scenario_id) { scenario.id }

  let(:headers) { { 'ACCEPT' => 'application/json' } }

  context 'when admin signed in' do
    before { sign_in admin }
    let(:valid_attributes) { { scenario: { name: 'updated name' } } }
    before { put "/scenarios/#{scenario_id}", params: valid_attributes, headers: headers }

    context 'when scenario exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the scenario' do
        updated_scenario = Scenario.find(scenario_id)
        expect(updated_scenario.name).to match(/updated name/)
      end
    end

    context 'when the scenario does not exist' do
      let(:scenario_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Scenario/)
      end
    end
  end
end
