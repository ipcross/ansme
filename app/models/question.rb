class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions
  belongs_to :user

  include Attachable
  include Votable
  include Commentable

  validates :title, :body, :user_id, presence: true

  after_create :autosubscribe_for_own

  def to_s
    self[:title]
  end

  private

  def autosubscribe_for_own
    user.subscribe!(id)
  end
end
