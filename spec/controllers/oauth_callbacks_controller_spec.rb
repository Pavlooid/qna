require "rails_helper"

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Github' do
    let(:oauth_data) { {'provider' => 'github', 'uid' => '123', info: { email: '123@mail.ru' } } }
    let(:oauth_data_no_email) { {'provider' => 'github', 'uid' => '123'} }

    context 'provider transmit email' do
      it 'finds user from oauth data' do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        expect(User).to receive(:find_for_oauth).with(oauth_data)
        get :github
      end

      context 'user exist' do
        let!(:user) { create(:user) }

        before do
          allow(User).to receive(:find_for_oauth).and_return(user)
          get :github
        end

        it 'login user if it exist' do
          expect(subject.current_user).to eq user
        end

        it 'redirect to root path' do
          expect(response).to redirect_to root_path
        end
      end

      context 'user does not exist' do
        before do
          allow(User).to receive(:find_for_oauth)
          get :github
        end

        it 'redirect to new_user_registration_path' do
          expect(response).to redirect_to new_user_registration_path
        end

        it 'does not login user' do
          expect(subject.current_user).to_not be
        end
      end
    end

    context 'provider does not transmit email' do
      it 'redirect to new_user_registration_path' do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data_no_email)
        expect(User).to receive(:find_for_oauth).with(oauth_data_no_email)
        get :github
        expect(response).to redirect_to new_user_registration_path
      end
    end
  end
end
