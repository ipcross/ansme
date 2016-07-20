class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  include Attachable
  include Votable
  include Commentable

  validates :body, :question_id, :user_id, presence: true

  after_commit :notify_users

  default_scope { order(best: :desc) }

  def set_best!
    transaction do
      question.answers.update_all(best: false, updated_at: Time.now)
      update!(best: true)
    end
  end

  private

  def notify_users
    users = question.users
    users.each do |user|
      NotificationMailer.delay.added_answer(user, self)
    end
  end
end
