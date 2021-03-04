class Category < ApplicationRecord
  # menuのアソシエーション
  has_many :menu_category, dependent: :destroy
  has_many :menus, through: :menu_category

  validates :name, presence: true
end
