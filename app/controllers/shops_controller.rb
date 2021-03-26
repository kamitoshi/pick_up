class ShopsController < ApplicationController
  before_action :only_shop!, only:[:index, :edit, :update, :destroy]
  before_action :set_shop, only:[:show, :edit, :update, :destroy]

  def index
    # @shop = Shop.find(current_shop.id)
    # @new_orders = Order.where(shop_id: @shop.id, status: 0)
    # @making_orders = Order.where(shop_id: @shop.id, status: 1)
    # @fix_orders = Order.where(shop_id: @shop.id, status: 2)
    # @week_sales_numbers = []
    # @week_sales_prices = []
    # @orders = Order.where(shop_id: @shop.id)
    # 7.times do |i|
    #   day = Date.today - i
    #   data = []
    #   total_price = 0
    #   @orders.each do |order|
    #     if order.takeaway_datetime.strftime("%Y/%m/%d") == day.strftime("%Y/%m/%d")
    #       data.push(order)
    #       total_price += order.total_payment
    #     end
    #   end
    #   @week_sales_numbers.push([date: day.strftime("%m/%d"), count: data.count])
    #   @week_sales_prices.push([date: day.strftime("%m/%d"), price: total_price])
    # end
  end

  def show
    @new_orders = Order.where(shop_id: @shop.id, status: 0)
    @fix_orders = Order.where(shop_id: @shop.id, status: 1)
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
    menus = @shop.menus
    @food_menus = menus.where(menu_type: 0)
    @drink_menus = menus.where(menu_type: 1)
    @dessert_menus = menus.where(menu_type: 2)
  end

  def edit
    redirect_to shop_path(current_shop) unless @shop == current_shop
  end

  def update
    if @shop == current_shop
      if @shop.update(shop_params)
        flash[:success] = "店舗情報を変更しました"
        redirect_to shop_path(@shop)
      else
        render :edit
      end
    else
      flash[:danger] = "他店の情報は編集できません"
      redirect_to shops_path
    end
  end

  def destroy
    if @shop == current_shop
      if @shop.destroy
        redirect_to delete_path
      else
        flash[:danger] = "退会できませんでした"
        redirect_to shop_path(current_shop)
      end
    else
      flash[:danger] = "他店を退会させることはできません"
      redirect_to shops_path
    end
  end

  private

  def shop_params
    params.require(:shop).permit(:name, :phone_number, :prefecture, :city, :address, :email, :introduction, :url, :is_active)
  end

  def set_shop
    @shop = Shop.find(params[:id])
  end

  def only_shop!
    unless shop_signed_in?
      redirect_to root_path
    end
  end
end
