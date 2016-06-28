class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user

  include Attachable
  include Votable
  include Commentable

  validates :title, :body, :user_id, presence: true

  def to_s
    self[:title]
  end
end
