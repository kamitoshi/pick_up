class CartItems::OrdersController < ApplicationController
  layout "users_layout"
  def new
    @order = Order.new
    @order_item = OrderItem.new
    @cart_items = current_user.cart_items
    @shop = @cart_items[0].menu.shop
  end

  def create
    @shop = current_user.cart_items[0].menu.shop
    @cart_items = current_user.cart_items
    @order = current_user.orders.build(order_params)
    @order.shop_id = @shop.id
    if @order.is_business_time_order?
      @order.numbering_reserve_number(@order.shop.target_date_order_count(@order.takeaway_datetime))
      if @order.save
        @cart_items.each do |cart_item|
          OrderItem.create(
            order_id: @order.id,
            menu_id: cart_item.menu.id,
            menu_name: cart_item.menu.name,
            menu_price: cart_item.menu.price,
            menu_amount: cart_item.amount
          )
          cart_item.destroy
        end
        OrderMailer.send_user_order(@order).deliver_later
        redirect_to orders_fix_path
      else
        flash[:danger] = "注文できませんでした。入力内容を確認してください"
        render :new
      end
    else
      flash.now[:danger] = "受け取り希望時間をご確認ください"
      render :new
    end
    if @order.save
      
    else
      flas.now[:danger] = "注文できませんでした。受け取り時間を確認してください。"
      render :new
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
