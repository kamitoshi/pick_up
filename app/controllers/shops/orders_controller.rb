class Shops::OrdersController < ApplicationController
  layout "shop_app"
  before_action :authenticate_shop!, only:[:index, :new_orders, :today_orders]
  before_action :admin_or_shop!
  
  def index
    @orders = Order.where(shop_id: current_shop.id).order(takeaway_datetime: "desc").page(params[:page]).per(20)
  end

  def new_orders
    @new_orders = Order.where(status: "新規注文").order(takeaway_datetime: "desc")
  end

  def today_orders
    orders = Order.where(shop_id: current_shop.id).order(takeaway_datetime: "desc")
    @new_orders = []
    @reception_orders = []
    @fix_orders = []
    @cancel_orders = []
    orders.each do |order|
      if order.status == "新規注文"
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
      OrderMailer.send_return_reception_order(@order).deliver_later
      redirect_to new_orders_shops_orders_path
    elsif params[:status] == "3"
      @order.status = 3
      @order.save
      flash[:danger] = "注文キャンセル完了。注文者にキャンセルメールを送付しました。"
      OrderMailer.send_return_cancel_order(@order).deliver_later
      redirect_to new_orders_shops_orders_path
    else
      flash[:danger] = "注文の返信に失敗しました。"
      redirect_to new_orders_shops_orders_path
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
