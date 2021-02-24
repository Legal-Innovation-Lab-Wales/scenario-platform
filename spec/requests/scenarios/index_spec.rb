# spec/requests/scenarios/index_spec.rb
require 'rails_helper'

RSpec.describe 'index scenarios (GET scenarios)', type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:alt_admin) { create(:user, :alt_admin) }
  let!(:scenarios) { create_list(:scenario, 10, user: admin) }
  let!(:alt_scenarios) { create_list(:scenario, 10, user: alt_admin) }
  let(:scenario_id) { scenarios.first.id }

  let(:headers) { { 'ACCEPT' => 'application/json' } }

  context 'when user not signed in' do
    before { get '/scenarios', headers: headers }

    it 'returns status code 401 Unauthorized' do
      expect(response).to have_http_status(401)
    end

    it 'returns an unauthorised message' do
      expect(response.body).to include('You need to sign in or sign up before continuing.')
    end
  end

  context 'when any user signed in' do
    before { sign_in user }
    before { get '/scenarios', headers: headers }

    it 'returns http status success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns json content' do
      expect(response.content_type).to include('application/json')
    end

    it 'returns 10 scenarios' do
      expect(Scenario.all.count).to eq(20)
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'expects scenarios to be from the correct organisation' do
      scenarios = JSON.parse(response.body)
      scenarios_user_ids = scenarios.map { |q| q['user_id'] }
      scenarios_user_org_ids = scenarios_user_ids.map { |user_id| User.find(user_id).organisation_id }
      expect(scenarios_user_org_ids.uniq).to eq([user.organisation_id])
    end

    it 'expects scenarios to be available' do
      scenarios = JSON.parse(response.body)
      available_map = scenarios.map { |q| q['available'] }
      expect(available_map).to all(be_truthy)
    end

    context 'when some scenarios are not available' do
      let!(:unavailable_scenarios) { create_list(:scenario, 10, :unavailable) }
      before { get '/scenarios', headers: headers }

      it 'returns http status success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns json content' do
        expect(response.content_type).to include('application/json')
      end

      it 'returns 10 scenarios' do
        expect(Scenario.all.count).to eq(30)
        expect(json.size).to eq(10)
      end

      it 'expects all returned scenarios to be available' do
        scenarios = JSON.parse(response.body)
        available_map = scenarios.map { |q| q['available'] }
        expect(available_map).to all(be_truthy)
      end
    end
  end

  context 'when admin signed in and scenarios not available' do
    before { sign_in admin }
    let!(:scenarios) { create_list(:scenario, 10, :unavailable) }
    before { get '/scenarios', headers: headers }

    it 'returns http status success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns json content' do
      expect(response.content_type).to include('application/json')
    end

    it 'returns scenarios' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'expects scenarios to be not available' do
      scenarios = JSON.parse(response.body)
      available_scenarios = scenarios.map { |q| q['available'] }
      expect(available_scenarios).to all(be_falsey)
    end
  end

end
