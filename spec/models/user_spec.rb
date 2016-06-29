require 'rails_helper'

RSpec.describe User do
  context "Assosiations" do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:votes) }
    it { should have_many(:authorizations).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  context "Validations" do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do
      context 'user exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with right data' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'should return user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with right data' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  describe '.send_daily_digest' do
    let!(:users) { create_list(:user, 2) }
    let!(:questions) { create_list(:question, 2, user: users.first, created_at: (Time.now - 1.day)) }
    let!(:question1) { create(:question, user: users.first, title: 'Question created today') }
    let!(:question2) { create(:question, user: users.first, title: 'Question created month ago', created_at: (Time.now - 30.day)) }

    it 'should send daily digest to all users' do
      users.each { |user| expect(DailyMailer).to receive(:digest).with(user, questions).and_call_original }
      User.send_daily_digest
    end
    it 'receives email with digest' do
      User.send_daily_digest
      open_email(users.first.email)
      expect(current_email).to have_content 'Yesterday list of questions'
      expect(current_email).to_not have_content 'Question created today'
      expect(current_email).to_not have_content 'Question created month ago'
      # current_email.save_and_open
    end
  end

  describe 'subscription methods' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let!(:question) { create(:question, user: user2) }

    describe 'subscribe!' do
      it 'creates subscription to question' do
        expect { user.subscribe!(question.id) }.to change(user.subscriptions, :count).by(1)
      end
    end

    describe 'unsubscribe!' do
      it 'deletes subscription to question' do
        create(:subscription, question: question, user: user)
        expect { user.unsubscribe!(question.id) }.to change(Subscription, :count).by(-1)
      end
    end

    describe 'subscribed?' do
      it 'returns true if user subscribed to question' do
        create(:subscription, question: question, user: user)
        expect(user).to be_subscribed(question)
      end

      it 'returns false if user dont subscribed to question' do
        expect(user).to_not be_subscribed(question)
      end
    end
  end
end
