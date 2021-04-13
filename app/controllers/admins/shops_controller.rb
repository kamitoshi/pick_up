class Admins::ShopsController < ApplicationController
  layout "shop_app"
  before_action :set_shop, only:[:show, :edit, :update, :destroy]
  def index
    @shops = Shop.all
  end

  def show
    @new_orders = Order.where(shop_id: @shop.id, status: 0)
    @reception_orders = Order.where(shop_id: @shop.id, status: 1)
    @fix_orders = Order.where(shop_id: @shop.id, status: 2)
    @cancel_orders = Order.where(shop_id: @shop.id, status: 3)
    @week_sales_numbers = []
    @week_sales_prices = []
    @orders = Order.where(shop_id: @shop.id)
    7.times do |i|
      day = Date.today - i
      data = []
      total_price = 0
      @orders.each do |order|
        if order.takeaway_datetime.strftime("%Y/%m/%d") == day.strftime("%Y/%m/%d")
          data.push(order)
          total_price += order.total_payment
        end
      end
      @week_sales_numbers.push([date: day.strftime("%m/%d"), count: data.count])
      @week_sales_prices.push([date: day.strftime("%m/%d"), price: total_price])
    end
  end

  def edit
    
  end

  def update
    if @shop.update(shop_params)
      flash[:success] = "変更を保存しました"
      redirect_to admins_shop_path(@shop)
    else
      flash[:danger] = "変更できませんでした"
      render :edit
    end
  end

  def destroy
    if @shop.destroy
      flash[:success] = "退会処理を実行しました"
      redirect_to delete_path
    else
      flash[:danger] = "退会処理ができませんでした"
      redirect_to admins_shop_path(@shop)
    end
  end


  private

  def shop_params
    params.require(:shop).permit(:name, :phone_number, :prefecture, :city, :address, :email, :introduction, :url, :is_active)
  end

  def set_shop
    @shop = Shop.find(params[:id])
  end
end
