class Shops::MenusController < ApplicationController
  layout "shop_app"
  before_action :authenticate_shop!
  def index
    @menus = Menu.where(shop_id: current_shop.id)
    @food_menus = []
    @drink_menus = []
    @dessert_menus = []
    @menus.each do |menu|
      if menu.menu_type == "フード"
        @food_menus.push(menu)
      elsif menu.menu_type == "ドリンク"
        @drink_menus.push(menu)
      elsif menu.menu_type == "デザート"
        @dessert_menus.push(menu)
      end
    end
  end

  def show
    @menu = Menu.find(params[:id])
    @menu_tag = MenuTag.new
  end
end
