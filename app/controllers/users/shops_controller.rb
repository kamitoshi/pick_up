class Users::ShopsController < ApplicationController
  before_action :set_shop_ransack
  def index
    @shops = Shop.where(is_active: true).page(params[:page]).per(20)
  end

  def search
    @search_shop = Shop.ransack(params[:q]) 
    @search_shops = @search_shop.result.where(is_active: true)
    @shops = @search_shops.page(params[:page]).per(20)
  end

  def show
    @shop = Shop.find(params[:id])
    unless @shop.is_active?
      redirect_to root_path
    end
    @menus = @shop.menus.where(is_active: true)
    @popular_menus = @menus.shuffle.first(4)
    @food_menus = @menus.where(menu_type: "フード")
    @drink_menus = @menus.where(menu_type: "ドリンク")
    @dessert_menus = @menus.where(menu_type: "デザート")
  end

  def infomation
    @shop = Shop.find(params[:id])
  end
end
