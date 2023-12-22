require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it 'should return author of question' do
    expect(user.author_of?(question)).to eq true
  end
end
