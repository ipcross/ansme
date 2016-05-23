class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :title, :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: proc { |a| a[:file].blank? }, allow_destroy: true

  def to_s
    self[:title]
  end
end
