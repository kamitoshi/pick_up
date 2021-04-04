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
    @shop = @menu.shop
    @amount = 1
  end

  def create
    @menu = Menu.find(params[:menu_id])
    @shop = @menu.shop
    orders = Order.where(shop_id: @menu.shop_id)
    @order = Order.new(order_params)
    if @order.takeaway_datetime.nil?
      @order.takeaway_datetime = Time.now + (@menu.estimated_time * 60)
    end
    @order.numbering_reserve_number(@order.shop.target_date_order_count(@order.takeaway_datetime))
    if @order.is_business_time_order?
      if params[:order][:amount].blank? || params[:order][:amount] == "0"
        @amount = params[:order][:amount]
        flash.now[:danger] = "注文できませんでした。注文品の個数を確認してください。"
        render :new
      else
        if @order.save
          order_item = @order.order_items.build(
            menu_id: @menu.id,
            menu_name: @menu.name,
            menu_price: @menu.price,
            menu_amount: params[:order][:amount].to_i
          )
          if order_item.save
            OrderMailer.send_user_order(@order).deliver_later
            redirect_to orders_fix_path
          else
            @amount = params[:order][:amount]
            flash.now[:danger] = "注文できませんでした。注文品の個数を確認してください。"
            render :new
          end
        else
          @amount = params[:order][:amount]
          flash.now[:danger] = "注文できませんでした。入力内容を確認してください"
          render :new
        end
      end
    else
      @amount = params[:order][:amount]
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
