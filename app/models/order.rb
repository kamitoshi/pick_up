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
    date = Date.today
    self.reserve_number = "#{date.strftime("%Y%m%d").to_s}-#{(count + 1).to_s}"
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

  # オーダーが定休日の注文だった場合を判断する
  def is_holiday_order?
    shop = self.shop
    holidays = shop.holidays
    takeaway_datetime = self.takeaway_datetime
    if holidays.present?
      holidays.each do |holiday|
        if holiday.weekday_before_type_cast == takeaway_datetime.wday
          return true
        end
      end
      return false
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
    if now + self.long_serve_time * 60 <= takeaway_datetime
      business_hours.each do |business_hour|
        if takeaway_datetime.strftime("%H:%M") >= business_hour.opening.strftime("%H:%M") && takeaway_datetime.strftime("%H:%M") <= business_hour.closing.strftime("%H:%M")
          return true
        end
      end
    end
    return false
  end

  # 受け取り希望時間が現在時刻より後になっているか
  def is_now_after?
    now = Time.now
    if now < takeaway_datetime
      return true
    else
      return false
    end
  end

  # 受け取り時間が、最低提供目安の時間より後か判断する
  def is_after_long_serve_time?
    now = Time.now
    if now + self.long_serve_time * 60 <= takeaway_datetime
      return true
    else
      return false
    end
  end

  # 受け取り時間が営業時間中のオーダーか判断する
  def is_business_hour_order?
    shop = self.shop
    business_hours = shop.business_hours
    takeaway_datetime = self.takeaway_datetime
    business_hours.each do |business_hour|
      openTime = business_hour.opening
      closeTime = business_hour.closing
      n = takeaway_datetime.strftime("%H%M").to_i
      if openTime == closeTime # 24時間営業の店の場合はこのパターン
        return true
      elsif openTime < closeTime
        if [*openTime.strftime("%H%M").to_i..closeTime.strftime("%H%M").to_i].include?(n)
          return true
        end
      else
        if [*0..closeTime.strftime("%H%M").to_i, *openTime.strftime("%H%M").to_i..2359].include?(n)
          return true
        end
      end
    end
    return false
  end

  # ラストオーダーを過ぎてからの営業中の注文の場合
  def is_between_lastOrder_to_close?
    shop = self.shop
    business_hours = shop.business_hours
    now = Time.now
    n = now.strftime("%H%M").to_i
    business_hours.each do |business_hour|
      lastOrder = business_hour.last_order
      closeTime = business_hour.closing
      if lastOrder == closeTime #ラストオーダーの概念が存在しない場合
        return false
      elsif lastOrder < closeTime
        if [*lastOrder.strftime("%H%M").to_i..closeTime.strftime("%H%M").to_i].include?(n)
          if self.takeaway_datetime.strftime("%Y年%m月%d日") == now.strftime("%Y年%m月%d日") && self.takeaway_datetime.strftime("%H%M").to_i <= closeTime.strftime("%H%M").to_i
            return true
          else
            return false
          end
        end
      else
        if [*0..closeTime.strftime("%H%M").to_i].include?(n)
          if self.takeaway_datetime.strftime("%Y年%m月%d日") == now.strftime("%Y年%m月%d日") && self.takeaway_datetime.strftime("%H%M").to_i <= closeTime.strftime("%H%M").to_i
            return true
          else
            return false
          end
        elsif [*lastOrder.strftime("%H%M").to_i..2359].include?(n)
          if self.takeaway_datetime.strftime("%Y年%m月%d日") == now.strftime("%Y年%m月%d日") && self.takeaway_datetime.strftime("%H%M").to_i <= closeTime.strftime("%H%M").to_i
            return true
          else
            return false
          end
        end
      end
    end
    return false
  end

  # 今の時間が現時刻の営業時間のラストオーダーを過ぎていいないか
  def is_after_last_order?
    
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
