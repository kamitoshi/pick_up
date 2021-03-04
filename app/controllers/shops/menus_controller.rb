class Shops::MenusController < ApplicationController
  def index
    @menus = Menu.where(shop_id: current_shop.id)
  end

  def show
    @menu = Menu.find(params[:id])
  end
end
