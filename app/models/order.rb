class Order < ApplicationRecord
  belongs_to :shop
  belongs_to :user

  has_many :order_items, dependent: :destroy

  enum status: {
    新規注文: 0, 受付注文: 1, 完了注文: 2, キャンセル注文: 3
  }

  # 該当のオーダーでいくらの料金が発生したのかを算出する
  def total_payment
    items = self.order_items
    result = 0
    items.each do |item|
      result += item.menu_price * item.menu_amount
    end
    return result
  end

  # 該当のオーダーでいくらの手数料が発生したのかを算出する
  def total_fee
    items = self.order_items
    result = 0
    items.each do |item|
      result += (item.menu_price * item.menu_fee / 100) * item.menu_amount
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

  # オーダーの中で一番提供時間が長いものを基準にするメソッド
  def long_serve_time
    order_items = self.order_items
    result = 0
    order_items.each do |item|
      if item.menu.estimated_time > result
        result = item.menu.estimated_time
      end
    end
    return result
  end
  
  # 受け取り時間が営業時間中のオーダーか判断する
  def is_business_time_order?
    shop = self.shop
    business_hours = shop.business_hours
    takeaway_datetime = self.takeaway_datetime
    now = Time.now
    if now + self.long_serve_time * 60 <= takeaway_datetime
      business_hours.each do |business_hour|
        if takeaway_datetime.strftime("%H:%M") >= business_hour.opening.strftime("%H:%M") && takeaway_datetime.strftime("%H:%M") <= business_hour.closing.strftime("%H:%M")
          return true
        end
      end
    end
    return false
  end

  def order_items_name
    if self.order_items.count == 1
      item = self.order_items[0]
      return item.menu_name
    else
      item = self.order_items[0]
      return item.menu_name
    end
  end
  
end
