class Shops::OrdersController < ApplicationController
  def index
    @orders = Order.where(shop_id: current_shop.id).order(takeaway_datetime: "desc")
  end

  def today_index
    orders = Order.where(shop_id: current_shop.id).order(takeaway_datetime: "desc")
    @new_orders = []
    @reception_orders = []
    @fix_orders = []
    @cancel_orders = []
    orders.each do |order|
      if order.status == "新規注文" && order.is_today?
        @new_orders.push(order)
      elsif order.status == "受付注文" && order.is_today?
        @reception_orders.push(order)
      elsif order.status == "完了注文" && order.is_today?
        @fix_orders.push(order)
      elsif order.status == "キャンセル注文" && order.is_today?
        @cancel_orders.push(order)
      end
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if params[:status] == "1"
      @order.status = 1
      @order.numbering_reserve_number(@order.shop.target_date_reception_order_count(@order.takeaway_datetime))
      @order.save
      flash[:success] = "注文受付完了。注文者に受付完了メールを送付しました。"
      redirect_to today_index_shops_orders_path
    elsif params[:status] == "3"
      @order.status = 3
      @order.save
      flash[:danger] = "注文キャンセル完了。注文者にキャンセルメールを送付しました。"
      redirect_to today_index_shops_orders_path
    else
      flash[:danger] = "変更できませんでした"
      redirect_to today_index_shops_orders_path
    end
  end

  private

  def order_params
    params.require(:order).permit(:user_id, :shop_id, :reserve_number, :takeaway_datetime, :requested, :status)
  end
  def order_item_params
    params.require(:order_item).permit(:order_id, :menu_id, :menu_name, :menu_price, :menu_amount)
  end

end
