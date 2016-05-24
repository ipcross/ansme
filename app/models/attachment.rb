class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true

  validates :file, presence: true
  validates :attachable_id, presence: true, on: :save
  validates :attachable_type, presence: true

  mount_uploader :file, FileUploader
end
