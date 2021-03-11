class Shop < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  enum prefecture: {
    北海道:1,
    青森県:2,岩手県:3,宮城県:4,秋田県:5,山形県:6,福島県:7,
    茨城県:8,栃木県:9,群馬県:10,埼玉県:11,千葉県:12,東京都:13,神奈川県:14,
    新潟県:15,富山県:16,石川県:17,福井県:18,山梨県:19,長野県:20,
    岐阜県:21,静岡県:22,愛知県:23,三重県:24,
    滋賀県:25,京都府:26,大阪府:27,兵庫県:28,奈良県:29,和歌山県:30,
    鳥取県:31,島根県:32,岡山県:33,広島県:34,山口県:35,
    徳島県:36,香川県:37,愛媛県:38,高知県:39,
    福岡県:40,佐賀県:41,長崎県:42,熊本県:43,大分県:44,宮崎県:45,鹿児島県:46,
    沖縄県:47
  }

  has_many :shop_images, dependent: :destroy

  has_many :menus, dependent: :destroy

  has_many :orders, dependent: :nullify

  def full_address
    self.prefecture + self.city + self.address
  end

  # 今月の集計(今月の今日までの売り上げ金額と件数)
  def month_sales_money
    orders = self.orders
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
  def month_sales_count
    orders = self.orders
    month_orders = []
    orders.each do |order|
      if order.takeaway_datetime.strftime("%Y/%m") == Date.today.strftime("%Y/%m") && order.takeaway_datetime.strftime("%Y/%m/%d") <= Date.today.strftime("%Y/%m/%d")
        month_orders.push(order)
      end
    end
    return month_orders.count
  end

  # 当日の売り上げ合計金額と件数を計算する
  def today_sales_money
    orders = self.orders
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
  def today_sales_count
    orders = self.orders
    today_orders = []
    orders.each do |order|
      if order.takeaway_datetime.strftime("%Y/%m/%d") == Date.today.strftime("%Y/%m/%d")
        today_orders.push(order)
      end
    end
    return today_orders.count
  end

  # 前日の売り上げ合計金額と件数を計算する
  def yesterday_sales_money
    orders = self.orders
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
  def yesterday_sales_count
    orders = self.orders
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
