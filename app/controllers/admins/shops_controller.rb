class Admins::ShopsController < ApplicationController
  before_action :set_shop, only:[:show, :edit, :update, :destroy]
  def index
    @shops = Shop.all
  end

  def show
  end

  def edit
    
  end

  def update
    if @shop.update(shop_params)
      flash[:success] = "変更を保存しました"
      redirect_to shop_path(@shop)
    else
      flash[:danger] = "変更できませんでした"
      render :edit
    end
  end

  def destroy
    if @shop.destroy
      flash[:success] = "退会処理を実行しました"
      redirect_to delete_path
    else
      flash[:danger] = "退会処理ができませんでした"
      redirect_to shop_path(current_shop)
    end
  end


  private

  def shop_params
    params.require(:shop).permit(:name, :phone_number, :prefecture, :city, :address, :email, :introduction, :url, :is_active)
  end

  def set_shop
    @shop = Shop.find(params[:id])
  end
end
