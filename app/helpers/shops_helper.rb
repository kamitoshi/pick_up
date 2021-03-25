module ShopsHelper

  def today_order_count(orders)
    array = []
    if orders.count != 0
      orders.each do |order|
        if order.takeaway_datetime.strftime("%Y/%m/%d") == Date.today.strftime("%Y/%m/%d")
          array.push(order)
        end
      end
      return array.count
    else
      return 0
    end
  end
end
