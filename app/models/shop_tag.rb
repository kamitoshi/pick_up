class ShopTag < ApplicationRecord
  belongs_to :shop

  validates :content, presence: true
end
