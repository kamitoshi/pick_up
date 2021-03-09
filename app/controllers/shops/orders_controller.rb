class Shops::OrdersController < ApplicationController
  def index
    @orders = Order.where(shop_id: current_shop.id).order(takeaway_datetime: "desc")
  end

  def today_index
    orders = Order.where(shop_id: current_shop.id).order(takeaway_datetime: "desc")
    @new_orders = []
    @making_orders = []
    @fix_orders = []
    orders.each do |order|
      if order.status == "注文中" && order.is_today?
        @new_orders.push(order)
      elsif order.status == "調理中" && order.is_today?
        @making_orders.push(order)
      elsif order.status == "完了" && order.is_today?
        @fix_orders.push(order)
      end
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.status == "注文中"
      @order.status = 1
      @order.save
      flash[:success] = "調理を開始しました。"
      redirect_to today_index_shops_orders_path
    elsif @order.status == "調理中"
      @order.status = 2
      @order.save
      flash[:success] = "完成したことが注文者に通知されます。"
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
