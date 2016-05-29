require 'rails_helper'

RSpec.describe Vote, type: :model do
  context "Assosiations" do
    it { should belong_to :user }
    it { should belong_to :votable }
  end
  context "Validations" do
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :votable_id }
    it { should validate_presence_of :votable_type }
    it { should validate_inclusion_of(:value).in_array([-1, 1]) }
    it { should validate_uniqueness_of(:votable_id).scoped_to([:user_id, :votable_type]) }
  end

  describe 'Votes methods' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user2) }

    describe 'voted_by?' do
      it 'should return true if answer is voted by user' do
        answer.votes.create(user: user, value: 1)
        expect(answer).to be_voted_by(user)
      end

      it 'should return false if answer is voted by user' do
        expect(answer).to_not be_voted_by(user)
      end
    end

    describe 'vote_up' do
      it 'should add up vote to answer' do
        expect { answer.vote_up(user) }.to change(answer.votes, :count).by(1)
        expect(answer.votes.first.value).to be(1)
      end

      it 'shouldnt add up vote to voted answer' do
        answer.votes.create(user: user, value: 1)

        expect { answer.vote_up(user) }.to_not change(answer.votes, :count)
      end
    end

    describe 'vote_down' do
      it 'should add down vote to answer' do
        expect { answer.vote_down(user) }.to change(answer.votes, :count).by(1)
        expect(answer.votes.first.value).to be(-1)
      end

      it 'shouldnt add up vote to voted answer' do
        answer.votes.create(user: user, value: -1)

        expect { answer.vote_down(user) }.to_not change(answer.votes, :count)
      end
    end

    describe 'delete_vote' do
      it 'should delete users vote' do
        answer.votes.create(user: user, value: 1)

        expect { answer.delete_vote(user) }.to change(answer.votes, :count).by(-1)
        expect(Vote.count).to be 0
      end
    end

    describe 'total_score' do
      let!(:user3) { create(:user) }

      it 'should return votable total score' do
        answer.votes.create(user: user, value: -1)
        answer.votes.create(user: user3, value: -1)

        expect(answer.total_score).to eq(-2)
      end
    end
  end
end
