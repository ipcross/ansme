require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:answer2) { create(:answer, question: question, user: user2) }

  describe 'GET #new' do
    before do
      sign_in(user)
      get :new, question_id: question
    end

    it 'assigns a new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid attributes' do
      it 'save answer for question' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to\
          change(question.answers, :count).by(1)
      end

      it 'save user_id for answer' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(answer.user_id).to eq(user.id)
      end

      it 'render empty' do
        post :create, answer: attributes_for(:answer), question_id: question, format: :js
        expect(response.body).to eq ''
      end
    end

    context 'with invalid attributes' do
      it 'not save answer for question' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not\
          change(Answer, :count)
      end

      it 'render create template' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Logged user' do
      before { sign_in(user) }
      before { answer }

      it 'delete answer' do
        expect { delete :destroy, id: answer, question_id: question, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirect to index' do
        delete :destroy, id: answer, question_id: question, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not logged user' do
      before { answer }
      it 'tries to delete answer' do
        expect { delete :destroy, id:  answer, question_id: question }.to change(Answer, :count).by(0)
      end

      it 'redirect to index' do
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    before do
      sign_in(user)
    end

    it 'assings the requested answer to @answer' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns th question' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, id: answer, question_id: question, answer: { body: 'new body' }, format: :js
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
    end
  end

  describe 'PATCH #set_best' do
    context 'Author of question' do
      before do
        sign_in(user)
      end

      it 'changes answer best attributes' do
        patch :set_best, id: answer, format: :js
        answer.reload

        expect(answer.best).to eq true
      end

      it 'render set_best template' do
        patch :set_best, id: answer, format: :js

        expect(response).to render_template :set_best
      end
    end

    context 'Not author of question' do
      it 'tries to change best answer' do
        sign_in(user2)
        patch :set_best, id: answer, format: :js

        expect(answer.best).to eq false
      end
    end
  end

  it_behaves_like "voted" do
    before { sign_in(user) }
    let(:votable) { answer2 }
    let(:own_votable) { answer }
  end
end
