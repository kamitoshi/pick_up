module AdminsHelper
  # 今月の集計(今月の今日までの売り上げ金額と件数)
  def month_sales_money(orders)
    month_orders = []
    result = 0
    orders.each do |order|
      if order.takeaway_datetime.strftime("%Y/%m") == Date.today.strftime("%Y/%m") && order.takeaway_datetime.strftime("%Y/%m/%d") <= Date.today.strftime("%Y/%m/%d")
        month_orders.push(order)
      end
    end
    month_orders.each do |month_order|
      result += month_order.total_payment
    end
    return result
  end
  def month_sales_count(orders)
    month_orders = []
    orders.each do |order|
      if order.takeaway_datetime.strftime("%Y/%m") == Date.today.strftime("%Y/%m") && order.takeaway_datetime.strftime("%Y/%m/%d") <= Date.today.strftime("%Y/%m/%d")
        month_orders.push(order)
      end
    end
    return month_orders.count
  end

  # 当日の売り上げ合計金額と件数を計算する
  def today_sales_money(orders)
    today_orders = []
    result = 0
    orders.each do |order|
      if order.takeaway_datetime.strftime("%Y/%m/%d") == Date.today.strftime("%Y/%m/%d")
        today_orders.push(order)
      end
    end
    today_orders.each do |today_order|
      result += today_order.total_payment
    end
    return result
  end
  def today_sales_count(orders)
    today_orders = []
    orders.each do |order|
      if order.takeaway_datetime.strftime("%Y/%m/%d") == Date.today.strftime("%Y/%m/%d")
        today_orders.push(order)
      end
    end
    return today_orders.count
  end

  # 前日の売り上げ合計金額と件数を計算する
  def yesterday_sales_money(orders)
    yesterday_orders = []
    result = 0
    orders.each do |order|
      if order.takeaway_datetime.strftime("%Y/%m/%d") == Date.yesterday.strftime("%Y/%m/%d")
        yesterday_orders.push(order)
      end
    end
    yesterday_orders.each do |yesterday_order|
      result += yesterday_order.total_payment
    end
    return result
  end
  def yesterday_sales_count(orders)
    yesterday_orders = []
    orders.each do |order|
      if order.takeaway_datetime.strftime("%Y/%m/%d") == Date.yesterday.strftime("%Y/%m/%d")
        yesterday_orders.push(order)
      end
    end
    return yesterday_orders.count
  end

  # 予約番号を採番するために必要なその日の注文件数を集計する
  def target_date_order_count(date)
    target_orders = []
    self.orders.each do |order|
      if date.strftime("%Y/%m/%d") == order.takeaway_datetime.strftime("%Y/%m/%d")
        target_orders.push(order)
      end
    end
    return target_orders.count
  end
end
