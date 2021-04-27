class ShopContact < ApplicationRecord
  validates :shop_name, presence: true
  validates :phone_number, presence: true
  validates :email, presence: true
end
