class HomeController < ApplicationController
  layout "users_layout"
  def index
    if admin_signed_in?
      redirect_to admins_path
    elsif shop_signed_in?
      redirect_to shop_path(current_shop)
    elsif user_signed_in?
      redirect_to menus_path
    end
  end

  def top
    
  end
end
