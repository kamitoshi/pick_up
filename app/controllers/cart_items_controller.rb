class CartItemsController < ApplicationController
  layout "users_layout"
  def index
    @cart_items = CartItem.where(user_id: current_user.id)
  end

  def create
    @menu = Menu.find(params[:menu_id])
    @cart_item = @menu.cart_items.build(cart_item_params)
    if @cart_item.save
      flash[:success] = "カートに追加しました"
      redirect_to user_cart_items_path(current_user)
    else
      flash[:danger] = "追加にできませんでした"
      redirect_to menus_path
    end
  end

  def update

  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    flash[:success] = "削除しました"
    redirect_to user_cart_items_path(current_user)
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:user_id, :menu_id, :amount)
  end
end
