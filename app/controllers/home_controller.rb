class HomeController < ApplicationController
  layout "no_header", only:[:about]
  before_action :set_menu_ransack
  def index
    if shop_signed_in?
      redirect_to shop_path(current_shop)
    elsif admin_signed_in?
      redirect_to admins_path
    end
    @recommend_menus = Menu.all.page(params[:page]).per(8)
    @popular_menus = Menu.all.page(params[:page]).per(15)
    @popular_shops = Shop.all.page(params[:page]).per(8)
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
