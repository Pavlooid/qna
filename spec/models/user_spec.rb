require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:authorizations).dependent(:destroy) }

  it 'should return author of question' do
    expect(user.author_of?(question)).to eq true
  end

  describe '.find_for_oauth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
