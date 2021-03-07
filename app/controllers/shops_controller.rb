class ShopsController < ApplicationController
  before_action :only_shop!, only:[:index, :edit, :update, :destroy]
  before_action :set_shop, only:[:show, :edit, :update, :destroy]

  def index
    
  end

  def show
    @new_orders = Order.where(shop_id: @shop.id, status: 0)
    @making_orders = Order.where(shop_id: @shop.id, status: 1)
    @fix_orders = Order.where(shop_id: @shop.id, status: 2)

    @today_sales_money = @shop.today_sales_money
    @today_sales_count = @shop.today_sales_count
    @month_sales_money = @shop.month_sales_money
    @month_sales_count = @shop.month_sales_count
    @yesterday_sales_money = @shop.yesterday_sales_money
    @yesterday_sales_count = @shop.yesterday_sales_count
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
      flash[:alert] = "他店の情報は編集できません"
      redirect_to shops_path
    end
  end

  def destroy
    if @shop == current_shop
      if @shop.destroy
        redirect_to delete_path
      else
        flash[:alert] = "退会できませんでした"
        redirect_to shop_path(current_shop)
      end
    else
      flash[:alert] = "他店を退会させることはできません"
      redirect_to shops_path
    end
  end

  def delete  
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
