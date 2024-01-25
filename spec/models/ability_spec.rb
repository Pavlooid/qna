require "rails_helper"

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { create(:question, author: user) }
    let(:other_question) { create(:question, author: other_user) }
    let(:answer) { create(:answer, author: user) }
    let(:other_answer) { create(:answer, author: other_user) }
    let(:gist_url) { 'https://gist.github.com/' }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Link }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }

    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, other_user }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, other_question }

    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, other_answer }

    context 'question with file' do
      before do
        question.files.attach(io: File.open("#{Rails.root}/Gemfile"), filename: 'Gemfile')
        other_question.files.attach(io: File.open("#{Rails.root}/Gemfile"), filename: 'Gemfile')
      end

      it { should be_able_to :destroy, question.files.first }
      it { should_not be_able_to :destroy, other_question.files.first }
    end

    context 'answer with file' do
      before do
        answer.files.attach(io: File.open("#{Rails.root}/Gemfile"), filename: 'Gemfile')
        other_answer.files.attach(io: File.open("#{Rails.root}/Gemfile"), filename: 'Gemfile')
      end

      it { should be_able_to :destroy, answer.files.first, author: user }
      it { should_not be_able_to :destroy, other_answer.files.first, author: other_user }
    end

    it { should be_able_to :like, other_question, author: user }
    it { should_not be_able_to :like, question, author: user }

    it { should be_able_to :dislike, other_question, author: user }
    it { should_not be_able_to :dislike, question, author: user }

    it { should be_able_to :like, other_answer, author: user }
    it { should_not be_able_to :like, answer, author: user }

    it { should be_able_to :dislike, other_answer, author: user }
    it { should_not be_able_to :dislike, answer, author: user }

    it { should be_able_to :destroy, create(:link, linkable: question, url: gist_url, name: 'My gist') }
    it { should_not be_able_to :destroy, create(:link, linkable: other_question, url: gist_url, name: 'My gist') }

    it { should be_able_to :best, create(:answer, question: question, author: other_user) }
    it { should_not be_able_to :best, create(:answer, question: other_question, author: user) }
  end
end
