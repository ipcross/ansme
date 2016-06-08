class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:destroy, :show, :update, :set_best]
  before_action :load_question, only: [:new, :create]

  include Voted

  def new
    @answer = @question.answers.new
  end

  def set_best
    @question = @answer.question
    @answer.set_best! if @question.user == current_user && !@answer.best
    @comment = Comment.new
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
    @comment = Comment.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    @comment = Comment.new
    if @answer.save
      PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: @answer.to_json,
        attachments: answer_attachments(@answer)
      render nothing: true
    else
      render :create
    end
  end

  def destroy
    @question = @answer.question
    @answer.destroy if @answer.user == current_user
  end

  private

  def answer_attachments(answer)
    arr = []
    answer.attachments.each_with_index do |attachment, i|
      arr[i] = { name: attachment.file.identifier, url: attachment.file.url, id: attachment.id }
    end
    arr.to_json
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end
