class SalesController < ApplicationController
  layout "shop_app"
  before_action :admin_or_shop!
  before_action :set_shop

  def index
    @orders = @shop.orders.where(status: "受付注文")
    @sales_count = @orders.count
    @sales_price = 0
    @sales_fee = 0
    @orders.each do |order|
      @sales_price += order.total_payment
      @sales_fee += order.total_fee
    end
  end

  def month

  end

  def year

  end

  def show
  end

  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end
end
