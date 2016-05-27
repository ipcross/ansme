class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user

  include Attachable
  include Votable

  validates :title, :body, :user_id, presence: true

  def to_s
    self[:title]
  end
end
