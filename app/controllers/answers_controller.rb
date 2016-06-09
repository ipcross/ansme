class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:destroy, :update, :set_best]
  before_action :load_question, only: [:new, :create]
  after_action :publish_answer, only: :create

  include Voted

  respond_to :js
  respond_to :json, only: :create

  def new
    @answer = @question.answers.new
  end

  def set_best
    @answer.set_best! if @question.user == current_user && !@answer.best
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    @answer.save
  end

  def destroy
    @answer.destroy if @answer.user == current_user
  end

  private

  def publish_answer
    PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: @answer.to_json,
      attachments: answer_attachments(@answer) if @answer.valid?
  end

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
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end
