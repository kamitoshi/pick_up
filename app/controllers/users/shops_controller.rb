class Users::ShopsController < ApplicationController
  before_action :set_shop_ransack
  def index
    @shops = Shop.all.page(params[:page]).per(20)
  end

  def search
    @search_shop = Shop.ransack(params[:q]) 
    @search_shops = @search_shop.result
    @shops = @search_shop.result.page(params[:page]).per(20)
  end

  def show
    @shop = Shop.find(params[:id])
    @menus = @shop.menus
    @food_menus = @menus.where(menu_type: "フード")
    @drink_menus = @menus.where(menu_type: "ドリンク")
    @dessert_menus = @menus.where(menu_type: "デザート")
  end
end
