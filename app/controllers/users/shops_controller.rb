class Users::ShopsController < ApplicationController
  def index
    @shops = Shop.all
  end

  def show
    @shop = Shop.find(params[:id])
    @menus = @shop.menus
    @food_menus = @menus.where(menu_type: "フード")
    @drink_menus = @menus.where(menu_type: "ドリンク")
    @dessert_menus = @menus.where(menu_type: "デザート")
  end
end
