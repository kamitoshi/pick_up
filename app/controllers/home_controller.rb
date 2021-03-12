class HomeController < ApplicationController
  def index
    if admin_signed_in?
      redirect_to admins_path
    elsif shop_signed_in?
      redirect_to shops_path
    elsif user_signed_in?
      redirect_to menus_path
    end
  end
end
