module SalesHelper

  # オーダーの中のメニュー件数の合計
  def menu_sale_count(menu, orders)
    result = 0
    orders.each do |order|
      order.order_items.each do |item|
        if item.menu_name == menu.name
          result += item.menu_amount
        end
      end
    end
    return result
  end

  # オーダーの中のメニュー金額の合計
  def menu_sale_price(menu, orders)
    result = 0
    orders.each do |order|
      order.order_items.each do |item|
        if item.menu_name == menu.name
          result += item.menu_price * item.menu_amount
        end
      end
    end
    return result
  end

  # オーダーの中のメニューごとの手数料の合計
  def menu_sale_fee(menu, orders)
    result = 0
    orders.each do |order|
      order.order_items.each do |item|
        if item.menu_name == menu.name
          result += (item.menu_price * item.menu_fee / 100) * item.menu_amount
        end
      end
    end
    return result
  end

  def month_sale_count(date, orders)
    
  end

end
