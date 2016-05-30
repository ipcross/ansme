class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  include Attachable
  include Votable

  validates :body, :question_id, :user_id, presence: true

  default_scope { order(best: :desc) }

  def set_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
