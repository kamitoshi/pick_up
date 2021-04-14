class Admins::MenusController < ApplicationController
  layout "shop_app"
  def index
    @menus = Menu.all.page(params[:page]).per(50)
  end

  def show
    @menu = Menu.find(params[:id])
  end
end
