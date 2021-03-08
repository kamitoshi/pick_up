class Order < ApplicationRecord
  belongs_to :shop
  belongs_to :user

  has_many :order_items, dependent: :destroy

  validates :reserve_number, presence: true
  validates :takeaway_datetime, presence: true

  enum status: {
    注文中: 0, 調理中: 1, 受け取り待ち: 2, 完了: 3
  }

  # 該当のオーダーでいくらの料金が発生したのかを判別するメソッド
  def total_payment
    items = self.order_items
    result = 0
    items.each do |item|
      result += item.menu_price * item.menu_amount
    end
    return result
  end

  # 予約番号を採番するメソッド
  def numbering_reserve_number(count)
    self.reserve_number = count + 1
  end

end
