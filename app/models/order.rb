class Order < ApplicationRecord
  belongs_to :shop
  belongs_to :user

  has_many :order_items, dependent: :destroy

  validates :reserve_number, presence: true
  validates :takeaway_datetime, presence: true

  enum status: {
    注文中: 0, 調理中: 1, 完了: 2
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

  # 本日中のオーダーかどうか判断
  def is_today?
    if self.takeaway_datetime.strftime("%Y年%m月%d日") == Date.today.strftime("%Y年%m月%d日")
      return true
    else
      return false
    end
  end
  
  # 受け取り時間が営業時間中のオーダーか判断する
  def is_business_time_order?
    shop = self.shop
    business_hours = shop.business_hours
    takeaway_datetime = self.takeaway_datetime
    now = Time.now
    if now + 30 * 60 < takeaway_datetime
      business_hours.each do |business_hour|
        if takeaway_datetime.strftime("%H:%M") >= business_hour.opening.strftime("%H:%M") && takeaway_datetime.strftime("%H:%M") <= business_hour.closing.strftime("%H:%M")
          return true
        end
      end
    end
    return false
  end
  
end
