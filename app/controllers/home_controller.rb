class HomeController < ApplicationController
  layout "no_header", only:[:about, :store]
  before_action :set_menu_ransack
  def index
    if shop_signed_in?
      redirect_to shop_path(current_shop)
    elsif admin_signed_in?
      redirect_to admins_path
    end
    menus = Menu.joins(:shop).where(shops:{is_active: true}).where(is_active: true)
    shops = Shop.where(is_active: true)
    @recommend_menus = menus.page(params[:page]).per(8)
    @popular_menus = menus.page(params[:page]).per(15)
    @popular_shops = shops.where(is_active: true).page(params[:page]).per(8)
  end

  def top
    if shop_signed_in?
      redirect_to shop_path(current_shop)
    elsif admin_signed_in?
      redirect_to admins_path
    end
    @recommend_menus = Menu.all.page(params[:page]).per(8)
    @popular_menus = Menu.all.page(params[:page]).per(15)
    @popular_shops = Shop.all.page(params[:page]).per(8)
  end

  def anout

  end

  def method

  end

  def store

  end

  def privacy

  end

  def term
    
  end
end
