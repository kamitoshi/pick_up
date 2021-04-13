class ApplicationController < ActionController::Base

  def admin_or_shop!
    unless admin_signed_in? || shop_signed_in?
      flash[:danger] = "該当のページは店舗ユーザーとしてログインしていない場合閲覧できません"
      redirect_to new_shop_session_path
    end
  end

  def admin_or_user!
    unless admin_signed_in? || user_signed_in?
      flash[:danger] = "ログインしてください"
      redirect_to new_user_session_path
    end
  end

  # 今年1年のオーダーを引き出すため
  def this_year_orders(orders)
    result = []
    orders.each do |order|
      if order.takeaway_datetime.strftime("%Y") == Date.today.strftime("%Y")
        result.push(order)
      end
    end
  end

  # 今年の月単位での売上を算出するため
  def month_total_payment(orders, month)
    result = 0
    orders.each do |order|
      if order.takeaway_datetime.strftime("%m") == month
        result += order.total_payment
      end
    end
    return result
  end

  # 検索のため
  def set_menu_ransack
    @q = Menu.ransack(params[:q])
  end
  def set_shop_ransack
    @q = Shop.ransack(params[:q])
  end

end
