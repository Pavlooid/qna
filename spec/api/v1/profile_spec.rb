require "rails_helper"

describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT-TYPE" => "application/json",
                    "ACCEPT" => 'application/json'} }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it_behaves_like 'providable fields' do
        let(:all_fields) { %w[id email admin created_at updated_at] }
        let(:object) { me }
        let(:object_response) { json['user']}
      end

      it 'does not returns private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/index' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:users) { create_list(:user, 2) }
      let(:me) { users.first }
      let(:other_user) { users.last }
      let(:user_responce) { json['users'].first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of users expect me' do
        expect(json['users'].size).to eq 1
      end

      it_behaves_like 'providable fields' do
        let(:all_fields) { %w[id email admin created_at updated_at] }
        let(:object) { other_user }
        let(:object_response) { user_responce }
      end

      it 'does not returns private fields' do
        %w[password encrypted_password].each do |attr|
          expect(user_responce).to_not have_key(attr)
        end
      end
    end
  end
end
