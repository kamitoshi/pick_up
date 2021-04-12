class HomeController < ApplicationController
  layout "shop_app", only:[:top]
  before_action :set_menu_ransack
  def index
    if shop_signed_in?
      redirect_to shops_path
    elsif admin_signed_in?
      redirect_to admins_path
    end
    @recommend_menus = Menu.all.page(params[:page]).per(10)
    @popular_menus = Menu.all.page(params[:page]).per(15)
    @popular_shops = Shop.all.page(params[:page]).per(6)
  end

  def top
  end

  def anout

  end

  def method

  end

  def privacy

  end

  def term
    
  end
end
