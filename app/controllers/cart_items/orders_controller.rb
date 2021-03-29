class CartItems::OrdersController < ApplicationController
  layout "users_layout"
  def new
    @order = Order.new
    @order_item = OrderItem.new
    @cart_items = current_user.cart_items
  end

  def create
    @shop = current_user.cart_items[0].menu.shop
    @order = Order.new(order_params)
    @order.user_id = current_user.id
    @order.shop_id = @shop.id
    @order.numbering_reserve_number(@order.shop.target_date_order_count(@order.takeaway_datetime))
    if @order.save
      @cart_items = current_user.cart_items
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
      redirect_to orders_fix_path
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
