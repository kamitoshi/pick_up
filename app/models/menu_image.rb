class MenuImage < ApplicationRecord
  belongs_to :menu

  mount_uploader :file_name, MenusUploader

  validates :file_name, presence: true
end
