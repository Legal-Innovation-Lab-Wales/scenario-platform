# spec/requests/scenarios/delete_spec.rb
require 'rails_helper'

RSpec.describe 'delete scenario (DELETE scenario)', type: :request do
  let(:admin) { create(:user, :admin) }
  let!(:scenario) { create(:scenario, user: admin) }
  let(:scenario_id) { scenario.id }

  let(:headers) { { 'ACCEPT' => 'application/json' } }

  context 'when admin signed in' do
    before { sign_in admin }
    before { delete "/scenarios/#{scenario_id}", headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'deletes the record' do
      expect { Scenario.find(scenario_id) }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
