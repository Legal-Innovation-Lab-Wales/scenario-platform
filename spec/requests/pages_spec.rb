# spec/requests/pages_spec.rb
require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  let(:user) { create(:user) }

  describe 'GET root' do
    before { get '/' }
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /guide' do
    before { sign_in user }
    before { get '/guide' }
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /app' do
    before { sign_in user }
    before { get '/app' }
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end

end
