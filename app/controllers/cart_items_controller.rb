class CartItemsController < ApplicationController
  def index
    @cart_items = CartItem.where(user_id: current_user.id)
  end

  def create
    @menu = Menu.find(params[:menu_id])
    @cart_item = @menu.cart_items.build(user_id: current_user.id, amount: 1)
    if @cart_item.save
      flash[:success] = "カートに追加しました"
      redirect_to menus_path
    else
      flash[:danger] = "追加に失敗しました"
      redirect_to menus_path
    end
  end

  def update

  end

  def destroy

  end

  private

  def cartItems_params
    params.require(:cart_item).permit(:user_id, :menu_id, :amount)
  end
end
