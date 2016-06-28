require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  sign_in_user
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: other_user) }

  describe 'POST #create' do
    it 'creates new subscription' do
      expect do
        post :create, question_id: question.id, format: :json
      end.to change(@user.subscriptions, :count).by(1) && change(question.subscriptions, :count).by(1)
    end

    it 'assigns question to @question' do
      post :create, question_id: question.id, format: :json
      expect(assigns(:question)).to eq question
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes existing subscription' do
      create(:subscription, question_id: question.id, user_id: @user.id)
      expect do
        delete :destroy, question_id: question.id, format: :json
      end.to change(@user.subscriptions, :count).by(-1) && change(question.subscriptions, :count).by(-1)
    end

    it 'assigns question to @question' do
      post :create, question_id: question.id, format: :json
      expect(assigns(:question)).to eq question
    end
  end
end
