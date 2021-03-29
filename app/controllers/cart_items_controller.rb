class CartItemsController < ApplicationController
  layout "users_layout"
  def index
    if user_signed_in?
      @cart_items = CartItem.where(user_id: current_user.id)
    else
      flash[:danger] = "ログインしてください"
      redirect_to new_user_session_path
    end
  end

  def create
    @menu = Menu.find(params[:menu_id])
    if user_signed_in?
      @cart_item = @menu.cart_items.build(cart_item_params)
      if @cart_item.save
        flash[:success] = "カートに追加しました"
        redirect_to user_cart_items_path(current_user)
      else
        flash[:danger] = "追加にできませんでした"
        redirect_to menus_path
      end
    else
      flash[:danger] = "カートに追加するにはログインが必要です"
      redirect_to root_path
    end
  end

  def update
    if user_signed_in?
      @cart_item = CartItem.find(params[:id])
      if params[:amount] == "minus"
        @cart_item.amount = @cart_item.amount - 1
      elsif params[:amount] == "plus"
        @cart_item.amount = @cart_item.amount + 1
      end

      if @cart_item.save
        redirect_to user_cart_items_path(current_user)
      else
        flash[:danger] = "変更できませんでした"
        redirect_to user_cart_items_path(current_user)
      end
    else
      flash[:danger] = "カートの商品を変更するにはログインが必要です"
      redirect_to new_user_session_path
    end
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
