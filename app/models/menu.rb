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

  # 公開中か公開停止中かを表示する
  def public_status
    if self.is_active?
      return "公開中"
    else
      return "非公開"
    end
  end

  def main_image
    return self.menu_images.find_by(is_main: true)
  end

  def images
    return self.menu_images.order(is_main: "desc")
  end


  # メインの画像以外をサムネイルで表示する
  def not_main_images
    return self.menu_images.where(is_main: false)
  end

end
