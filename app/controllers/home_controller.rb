class HomeController < ApplicationController
  layout "shop_app", only:[:top]
  def index
    if shop_signed_in?
      redirect_to shops_path
    end
    @menus = Menu.all
    @shops = Shop.all
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
