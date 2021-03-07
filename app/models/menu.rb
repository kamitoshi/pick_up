class Menu < ApplicationRecord
  belongs_to :shop

  has_many :order_items

  # categoryのアソシエーション
  has_many :menu_category, dependent: :destroy
  has_many :categories, through: :menu_category

  enum menu_type: {
    フード: 0, ドリンク: 1, デザート: 2
  }
  enum genre: {
    和食: 0, フレンチ: 1, イタリアン: 2, 中華料理: 3, ロシア料理: 4, 創作料理: 5, その他: 6
  }

end
