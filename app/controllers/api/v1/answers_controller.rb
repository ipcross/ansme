module Api
  module V1
    class AnswersController < Api::V1::BaseController
      before_action :load_question, only: [:index]
      before_action :load_answer, only: [:show]

      authorize_resource class: Answer

      def index
        @answers = @question.answers
        respond_with @answers, each_serializer: AnswerCollectionSerializer
      end

      def show
        respond_with @answer
      end

      private

      def load_question
        @question = Question.find(params[:question_id])
      end

      def load_answer
        @answer = Answer.find(params[:id])
      end
    end
  end
end
