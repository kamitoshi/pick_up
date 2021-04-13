class Admins::OrdersController < ApplicationController
  layout "shop_app"
  before_action :authenticate_admin!
  def index
    @orders = Order.all.order(takeaway_datetime: "desc").page(params[:page]).per(20)
  end
end
