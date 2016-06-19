module Api
  module V1
    class AnswersController < Api::V1::BaseController
      before_action :load_question, only: [:index, :create]
      before_action :load_answer, only: [:show]

      authorize_resource class: Answer

      def index
        @answers = @question.answers
        respond_with @answers, each_serializer: AnswerCollectionSerializer
      end

      def show
        respond_with @answer
      end

      def create
        @answer = @question.answers.new(answer_params)
        @answer.user = current_resource_owner
        @answer.save
        respond_with(@answer)
      end

      private

      def load_question
        @question = Question.find(params[:question_id])
      end

      def load_answer
        @answer = Answer.find(params[:id])
      end

      def answer_params
        params.require(:answer).permit(:body)
      end
    end
  end
end
