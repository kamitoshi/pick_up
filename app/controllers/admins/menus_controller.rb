class Admins::MenusController < ApplicationController
  layout "shop_app"
  def index
    @menus = Menu.all
  end

  def show
    @menu = Menu.find(params[:id])
  end
end
