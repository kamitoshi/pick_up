class ShopsController < ApplicationController
  layout "shop_app"
  before_action :admin_or_shop!
  before_action :set_shop, only:[:show, :edit, :update, :destroy]

  def index
    if shop_signed_in?
      redirect_to shop_path(current_shop)
    end
    @shops = Shop.all
  end

  def show
    @orders = Order.where(shop_id: @shop.id)
    @new_orders = @orders.where(status: "新規注文")
    @reception_orders = @orders.where(status: "受付注文")
    @fix_orders = @orders.where(status: "完了注文")
    @cancel_orders = @orders.where(status: "キャンセル注文")
    this_year_orders = this_year_orders(@reception_orders)
    @jan_total_payment = month_total_payment(this_year_orders, "01")
    @feb_total_payment = month_total_payment(this_year_orders, "02")
    @mar_total_payment = month_total_payment(this_year_orders, "03")
    @apr_total_payment = month_total_payment(this_year_orders, "04")
    @may_total_payment = month_total_payment(this_year_orders, "05")
    @jun_total_payment = month_total_payment(this_year_orders, "06")
    @jul_total_payment = month_total_payment(this_year_orders, "07")
    @aug_total_payment = month_total_payment(this_year_orders, "08")
    @sep_total_payment = month_total_payment(this_year_orders, "09")
    @oct_total_payment = month_total_payment(this_year_orders, "10")
    @nov_total_payment = month_total_payment(this_year_orders, "11")
    @dec_total_payment = month_total_payment(this_year_orders, "12")
    @week_sales_numbers = []
    @week_sales_prices = []
    7.times do |i|
      day = Date.today - i
      data = []
      total_price = 0
      @reception_orders.each do |order|
        if order.takeaway_datetime.strftime("%Y/%m/%d") == day.strftime("%Y/%m/%d")
          data.push(order)
          total_price += order.total_payment
        end
      end
      @week_sales_numbers.push([date: day.strftime("%m/%d"), count: data.count])
      @week_sales_prices.push([date: day.strftime("%m/%d"), price: total_price])
    end
    @month_orders_count = 0
    @month_orders_price = 0
    @month_orders_fee = 0
    @reception_orders.each do |order|
      if order.takeaway_datetime.strftime("%Y/%m") == Date.today.strftime("%Y/%m")
        @month_orders_count += 1
        @month_orders_price += order.total_payment
        @month_orders_fee += order.total_fee
      end
    end
    menus = @shop.menus
    @food_menus = menus.where(menu_type: 0)
    @drink_menus = menus.where(menu_type: 1)
    @dessert_menus = menus.where(menu_type: 2)
  end

  def edit
    
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
      redirect_to shop_path(@shop)
    end
  end

  def destroy
    if @shop == current_shop
      if @shop.destroy
        redirect_to delete_path
      else
        flash[:danger] = "退会できませんでした"
        redirect_to shop_path(@shop)
      end
    else
      flash[:danger] = "他店を退会させることはできません"
      redirect_to shop_path(@shop)
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
