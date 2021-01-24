# spec/requests/pages_request_spec.rb
require 'rails_helper'

RSpec.describe 'Pages', type: :request do

  describe 'GET root' do
    it 'returns http success' do
      get '/'
      expect(response).to have_http_status(:success)
    end
  end
  
#TODO uncomment after Alex's code is merged
=begin
  describe 'GET /guide' do
    it 'returns http success' do
      get '/guide'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /app' do
    it 'returns http success' do
      get '/app'
      expect(response).to have_http_status(:success)
    end
  end
=end

end
