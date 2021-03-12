class AdminsController < ApplicationController
  before_action :only_admin!, only:[:index, :edit, :update, :destroy]
  before_action :set_admin, only:[:show, :edit, :update, :destroy]

  def index
    @orders = Order.all
    @new_orders = Order.where(status: 0)
    @making_orders = Order.where(status: 1)
    @fix_orders = Order.where(status: 2)
    @week_sales_numbers = []
    @week_sales_prices = []
    @orders = Order.all
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
