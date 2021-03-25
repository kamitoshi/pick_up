class ShopImage < ApplicationRecord
  belongs_to :shop

  mount_uploader :file_name, ShopUploader

  validates :file_name, presence: true
end
