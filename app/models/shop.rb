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
  has_many :shop_tags, dependent: :destroy
  has_many :menus, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_many :holidays, dependent: :destroy
  has_many :business_hours, dependent: :destroy

  def full_address
    self.prefecture + self.city + self.address
  end

  # ショップが持っているメニューの最小値段を算出する
  def menus_min_price
    result = 0
    self.menus.each do |menu|
      if result == 0
        result = menu.price
      elsif result > menu.price
        result = menu.price
      end
    end
    return result
  end

  # ショップが持っているメニューの最短提供時間を算出
  def menus_min_serve_time
    result = 0
    self.menus.each do |menu|
      if result == 0
        result = menu.estimated_time
      elsif result > menu.estimated_time
        result = menu.estimated_time
      end
    end
    return result
  end

  # ショップが持っているメニューの最大提供時間を算出
  def menus_max_serve_time
    result = 0
    self.menus.each do |menu|
      if result == 0
        result = menu.estimated_time
      elsif result < menu.estimated_time
        result = menu.estimated_time
      end
    end
    return result
  end

  # すでに定休日として設定されているか判断する
  def already_set_holiday?(weekday)
    holidays = self.holidays
    holidays.each do |holiday|
      if holiday.weekday == weekday
        return true
      end
    end
    return false
  end

  # 今月の集計(今月の今日までの売り上げ金額と件数)
  def month_sales_money
    orders = self.orders
    month_orders = []
    result = 0
    orders.each do |order|
      if order.takeaway_datetime.strftime("%Y/%m") == Date.today.strftime("%Y/%m") && order.takeaway_datetime.strftime("%Y/%m/%d") <= Date.today.strftime("%Y/%m/%d")
        if order.status == "受付注文" || order.status == "完了注文"
          month_orders.push(order)
        end
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
        if order.status == "受付注文" || order.status == "完了注文"
          month_orders.push(order)
        end
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
        if order.status == "受付注文" || order.status == "完了注文"
          today_orders.push(order)
        end
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
        if order.status == "受付注文" || order.status == "完了注文"
          today_orders.push(order)
        end
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
        if order.status == "受付注文" || order.status == "完了注文"
          yesterday_orders.push(order)
        end
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
        if order.status == "受付注文" || order.status == "完了注文"
          yesterday_orders.push(order)
        end
      end
    end
    return yesterday_orders.count
  end

  # 予約番号を採番するために必要なその日の注文件数を集計する
  def target_date_reception_order_count(date)
    target_orders = []
    self.orders.each do |order|
      if date.strftime("%Y/%m/%d") == order.takeaway_datetime.strftime("%Y/%m/%d") && order.status == "受付注文"
        if order.status == "受付注文" || order.status == "完了注文"
          target_orders.push(order)
        end
      end
    end
    return target_orders.count
  end

  def main_image
    return self.shop_images.find_by(is_main: true)
  end

  # ショップの画像を最初のもの以外サムネイルで表示する
  def not_main_images
    return self.shop_images.where(is_main: false)
  end

end
