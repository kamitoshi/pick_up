class Users::ShopsController < ApplicationController
  layout "users_layout"
  def index
    @shops = Shop.all
  end

  def show
    @shop = Shop.find(params[:id])
  end
end
