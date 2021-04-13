class AdminsController < ApplicationController
  layout "shop_app"
  before_action :only_admin!, only:[:index, :edit, :update, :destroy]
  before_action :set_admin, only:[:show, :edit, :update, :destroy]

  def index
    @orders = Order.where(status: "受付注文")
    this_year_orders = this_year_orders(@orders)
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
    @week_sales_counts = []
    @week_sales_prices = []
    @week_sale_food_count = 0
    @week_sale_drink_count = 0
    @week_sale_dessert_count = 0
    7.times do |i|
      day = Date.today - i
      data = []
      total_price = 0
      @orders.each do |order|
        if order.takeaway_datetime.strftime("%Y/%m/%d") == day.strftime("%Y/%m/%d")
          data.push(order)
          total_price += order.total_payment
          order.order_items.each do |item|
            if item.menu.menu_type == "フード"
              @week_sale_food_count += item.menu_amount
            elsif item.menu.menu_type == "ドリンク"
              @week_sale_drink_count += item.menu_amount
            elsif item.menu.menu_type == "デザート"
              @week_sale_dessert_count += item.menu_amount
            end
          end
        end
      end
      @week_sales_counts.push([date: day.strftime("%m/%d"), count: data.count])
      @week_sales_prices.push([date: day.strftime("%m/%d"), price: total_price])
    end
    @month_orders_count = 0
    @month_orders_price = 0
    @month_orders_fee = 0
    @orders.each do |order|
      if order.takeaway_datetime.strftime("%Y/%m") == Date.today.strftime("%Y/%m")
        @month_orders_count += 1
        @month_orders_price += order.total_payment
        @month_orders_fee += order.total_fee
      end
    end
  end

  def show
  end

  def edit
    redirect_to admin_path(current_admin) unless @admin == current_admin
  end

  def update
    if @admin == current_admin
      if @admin.update(admin_params)
        flash[:success] = "情報を変更しました"
        redirect_to admin_path(@admin)
      else
        render :edit
      end
    else
      flash[:alert] = "情報は編集できません"
      redirect_to admins_path
    end
  end

  def destroy
    if @admin == current_admin
      if @admin.destroy
        redirect_to delete_path
      else
        flash[:alert] = "退会できませんでした"
        redirect_to admin_path(current_admin)
      end
    else
      flash[:alert] = "他店を退会させることはできません"
      redirect_to admins_path
    end
  end

  def delete  
  end


  private

  def admin_params
    params.require(:admin).permit(:email)
  end

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def only_admin!
    unless admin_signed_in?
      redirect_to root_path
    end
  end
end
