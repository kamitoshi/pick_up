class Menu < ApplicationRecord
  belongs_to :shop

  has_many :menu_images
  has_many :menu_tags

  has_many :order_items
  has_many :cart_items

  # categoryのアソシエーション
  has_many :menu_category, dependent: :destroy
  has_many :categories, through: :menu_category

  validates :name, presence: true
  validates :price, presence: true
  validates :menu_type, presence: true

  enum menu_type: {
    フード: 0, ドリンク: 1, デザート: 2
  }

  # メインの画像以外をサムネイルで表示する
  def not_main_images
    images = self.menu_images
    return images.drop(1)
  end

end
