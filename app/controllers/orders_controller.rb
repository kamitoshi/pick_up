class OrdersController < ApplicationController
  layout "users_layout"
  def index
    @orders = Order.where(user_id: params[:user_id])
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
    @order_item = OrderItem.new
    @menu = Menu.find(params[:menu_id])
  end

  def create
    @menu = Menu.find(params[:menu_id])
    orders = Order.where(shop_id: @menu.shop_id)
    @order = Order.new(order_params)
    if @order.takeaway_datetime.nil?
      @order.takeaway_datetime = Time.now + (@menu.estimated_time * 60)
    end
    @order.numbering_reserve_number(@order.shop.target_date_order_count(@order.takeaway_datetime))
    if @order.is_business_time_order?
      if @order.save
        order_item = OrderItem.create(
          order_id: @order.id,
          menu_id: @menu.id,
          menu_name: @menu.name,
          menu_price: @menu.price,
          menu_amount: params[:amount]
        )
        OrderMailer.send_user_order(@order).deliver_later
        redirect_to orders_fix_path
      else
        flash[:danger] = "注文できませんでした。入力内容を確認してください"
        render "new"
      end
    else
      flash.now[:danger] = "受け取り希望時間をご確認ください"
      render :new
    end
  end

  def fix

  end

  def destroy

  end

  private

  def order_params
    params.require(:order).permit(:user_id, :shop_id, :reserve_number, :takeaway_datetime, :requested, :status)
  end
  def order_item_params
    params.require(:order_item).permit(:order_id, :menu_id, :menu_name, :menu_price, :menu_amount)
  end
end
