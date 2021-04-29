class OrdersController < ApplicationController
  before_action :admin_or_user!

  def index
    @orders = Order.where(user_id: params[:user_id]).order(takeaway_datetime: "desc").page(params[:page]).per(20)
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
    @order_item = OrderItem.new
    @menu = Menu.find(params[:menu_id])
    unless @menu.is_active?
      redirect_back(fallback_location: root_path)
    end
    @shop = @menu.shop
    @amount = 1
  end

  def create
    @menu = Menu.find(params[:menu_id])
    @shop = @menu.shop
    @order = Order.new(order_params)
    if @order.is_holiday_order?
      @amount = params[:order][:amount]
      flash.now[:danger] = "受け取り希望日は定休日です"
      render :new
    else
      if @order.is_now_after?
        if @order.is_business_hour_order?
          if Date.valid_date?(@order.takeaway_datetime.year.to_i, @order.takeaway_datetime.month.to_i, @order.takeaway_datetime.day.to_i)
            if @order.is_between_lastOrder_to_close?
              @amount = params[:order][:amount]
              flash.now[:danger] = "注文できませんでした。ラストオーダーを過ぎています"
              render :new
            else
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
                    menu_fee: @menu.fee,
                    menu_amount: params[:order][:amount].to_i
                  )
                  if @order.is_after_long_serve_time?
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
                    @order.destroy 
                    flash.now[:danger] = "注文できませんでした。受け取り時間を商品の提供目安より後に設定してください"
                    render :new
                  end
                else
                  @amount = params[:order][:amount]
                  flash.now[:danger] = "注文できませんでした。入力内容を確認してください。"
                  render :new
                end
              end
            end
          else
            @amount = params[:order][:amount]
            flash.now[:danger] = "注文できませんでした。"+@order.takeaway_datetime.strftime("%Y年%m月%d日")+"は存在しません。"
            render :new
          end
        else
          @amount = params[:order][:amount]
          flash.now[:danger] = "注文できませんでした。受け取り日時が営業時間外になっています"
          render :new
        end
      else
        @amount = params[:order][:amount]
        flash.now[:danger] = "注文できませんでした。受け取り日時が過去になっています"
        render :new
      end
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
