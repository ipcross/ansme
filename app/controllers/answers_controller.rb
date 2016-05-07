class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:destroy, :show]
  before_action :load_question, only: [:new, :create]
  before_action :load_owner, only: [:destroy]

  def new
    @answer = @question.answers.new
  end

  def show
  end

  def create
    answer = @question.answers.new(answer_params)
    answer.user_id = current_user.id
    if answer.save
      redirect_to answer.question
    else
      render :new
    end
  end

  def destroy
    question = @answer.question
    @answer.destroy
    redirect_to question
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_owner
    redirect_to @answer.question if @answer.user != current_user
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
