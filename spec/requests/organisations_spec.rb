# spec/requests/organisations_spec.rb
require 'rails_helper'

RSpec.describe '/organisations', type: :request do
  let(:organisation) { create(:organisation) }
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  # describe 'GET /index' do
  #   it 'renders a successful response' do
  #     get organisations_url
  #     expect(response).to be_successful
  #   end
  # end

  # describe 'GET /show' do
  #   before { get organisation_url(organisation), headers: headers }
  #
  #   it 'renders a successful response' do
  #     expect(response).to be_successful
  #   end
  #
  #   it 'returns json content' do
  #     expect(response.content_type).to include('application/json')
  #   end
  #
  #   it 'returns the organisation' do
  #     expect(json).not_to be_empty
  #     expect(json['id']).to eq(organisation.id)
  #   end
  # end

  # describe 'GET /new' do
  #   it 'renders a successful response' do
  #     get new_organisation_url
  #     expect(response).to be_successful
  #   end
  # end
  #
  # describe 'GET /edit' do
  #   it 'render a successful response' do
  #     organisation = Organisation.create! valid_attributes
  #     get edit_organisation_url(organisation)
  #     expect(response).to be_successful
  #   end
  # end

  # describe 'POST /create' do
  #   context 'with valid parameters' do
  #     it 'creates a new Organisation' do
  #       expect {
  #         post organisations_url, params: { organisation: valid_attributes }
  #       }.to change(Organisation, :count).by(1)
  #     end
  #
  #     it 'redirects to the created organisation' do
  #       post organisations_url, params: { organisation: valid_attributes }
  #       expect(response).to redirect_to(organisation_url(Organisation.last))
  #     end
  #   end
  #
  #   context 'with invalid parameters' do
  #     it 'does not create a new Organisation' do
  #       expect {
  #         post organisations_url, params: { organisation: invalid_attributes }
  #       }.to change(Organisation, :count).by(0)
  #     end
  #
  #     it "renders a successful response (i.e. to display the 'new' template)" do
  #       post organisations_url, params: { organisation: invalid_attributes }
  #       expect(response).to be_successful
  #     end
  #   end
  # end
  #
  # describe 'PATCH /update' do
  #   context 'with valid parameters' do
  #     let(:new_attributes) {
  #       skip('Add a hash of attributes valid for your model')
  #     }
  #
  #     it 'updates the requested organisation' do
  #       organisation = Organisation.create! valid_attributes
  #       patch organisation_url(organisation), params: { organisation: new_attributes }
  #       organisation.reload
  #       skip('Add assertions for updated state')
  #     end
  #
  #     it 'redirects to the organisation' do
  #       organisation = Organisation.create! valid_attributes
  #       patch organisation_url(organisation), params: { organisation: new_attributes }
  #       organisation.reload
  #       expect(response).to redirect_to(organisation_url(organisation))
  #     end
  #   end
  #
  #   context 'with invalid parameters' do
  #     it "renders a successful response (i.e. to display the 'edit' template)" do
  #       organisation = Organisation.create! valid_attributes
  #       patch organisation_url(organisation), params: { organisation: invalid_attributes }
  #       expect(response).to be_successful
  #     end
  #   end
  # end
  #
  # describe 'DELETE /destroy' do
  #   it 'destroys the requested organisation' do
  #     organisation = Organisation.create! valid_attributes
  #     expect {
  #       delete organisation_url(organisation)
  #     }.to change(Organisation, :count).by(-1)
  #   end
  #
  #   it 'redirects to the organisations list' do
  #     organisation = Organisation.create! valid_attributes
  #     delete organisation_url(organisation)
  #     expect(response).to redirect_to(organisations_url)
  #   end
  # end
end
