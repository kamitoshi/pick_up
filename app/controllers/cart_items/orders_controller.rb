class CartItems::OrdersController < ApplicationController
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
    if @order.is_holiday_order?
      @amount = params[:order][:amount]
      flash.now[:danger] = "受け取り希望日は定休日です"
      render :new
    else
      if @order.is_now_after?
        if @order.is_business_hour_order?
          if @order.is_between_lastOrder_to_close?
            flash.now[:danger] = "注文できませんでした。ラストオーダーを過ぎています"
            render :new
          else
            if @order.save
              @cart_items.each do |cart_item|
                OrderItem.create(
                  order_id: @order.id,
                  menu_id: cart_item.menu.id,
                  menu_name: cart_item.menu.name,
                  menu_price: cart_item.menu.price,
                  menu_fee: cart_item.menu.fee,
                  menu_amount: cart_item.amount
                )
              end
              if @order.is_after_long_serve_time?
                @cart_items.destroy_all
                OrderMailer.send_user_order(@order).deliver_later
                redirect_to orders_fix_path
              else
                @order.destroy 
                flash.now[:danger] = "注文できませんでした。受け取り時間を商品の提供目安より後に設定してください"
                render :new
              end
            else
              flash[:danger] = "注文できませんでした。入力内容を確認してください"
              render :new
            end
          end
        else
          flash.now[:danger] = "注文できませんでした。受け取り日時が営業時間外になっています"
          render :new
        end
      else
        flash.now[:danger] = "注文できませんでした。受け取り日時が過去になっています"
        render :new
      end
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
