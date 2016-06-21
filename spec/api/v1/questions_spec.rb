require 'rails_helper'

describe 'Questions API' do
  let(:access_token) { create(:access_token) }

  describe 'GET /index' do
    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { do_request(access_token: access_token.token) }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do
    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end

    let!(:question) { create(:question) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:comment) { create(:comment, commentable: question) }
      let!(:attachment) { create(:attachment, attachable: question) }

      before { do_request(access_token: access_token.token) }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns question' do
        expect(response.body).to have_json_size(1)
      end

      %w(id title body created_at updated_at).each do |attr|
        it 'question contains #{attr}' do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/comments")
        end

        %w(id body created_at updated_at user_id).each do |attr|
          it 'contains #{attr}' do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/attachments")
        end

        it 'contains url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/url")
        end
      end
    end
  end

  describe 'POST #create' do
    def do_request(options = {})
      post '/api/v1/questions', { format: :json }.merge(options)
    end

    it_behaves_like "API Authenticable"

    context 'authorized' do
      context 'with valid question data' do
        let(:post_valid_question) do
          do_request(access_token: access_token.token, question: attributes_for(:question))
        end

        it 'returns 201 status' do
          post_valid_question
          expect(response).to be_success
        end

        it 'creates question' do
          expect { post_valid_question }.to change(Question, :count).by(1)
        end
      end

      context 'with invalid question data' do
        let(:post_invalid_question) do
          do_request(access_token: access_token.token, question: attributes_for(:invalid_question))
        end

        it 'returns 422 status' do
          post_invalid_question
          expect(response).to_not be_success
        end

        it 'not create question' do
          expect { post_invalid_question }.to_not change(Question, :count)
        end
      end
    end
  end
end
