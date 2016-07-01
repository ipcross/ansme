require 'rails_helper'

RSpec.describe Search, type: :sphinx do
  describe 'full_search method' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:comment) { create(:comment, commentable: question, user: user) }

    it 'returns right objects' do
      index

      expect(Search.full_search('', '')).to match_array [user, question, answer, comment]
      expect(Search.full_search(question.title, 'questions')).to match_array [question]
      expect(Search.full_search(answer.body, 'answers')).to match_array [answer]
      expect(Search.full_search(comment.body, 'comments')).to match_array [comment]
      expect(Search.full_search(user.email, 'users')).to match_array [user]
    end

    it 'returns empty arr if context is invalid' do
      index

      expect(Search.full_search('', 'invalid')).to match_array []
    end
  end
end
