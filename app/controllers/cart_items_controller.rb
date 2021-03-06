class CartItemsController < ApplicationController
  before_action :admin_or_user!
  def index
    @cart_items = CartItem.where(user_id: current_user.id)
  end

  def create
    @menu = Menu.find(params[:menu_id])
    if current_user.cart_items.blank?
      if current_user.cart_already_include(@menu)
        @cart_item = CartItem.find_by(menu_id: @menu.id, user_id: current_user.id)
        @cart_item.update(
          amount: @cart_item.amount + params[:cart_item][:amount].to_i
        )
        flash[:success] = "カートに追加しました"
        redirect_to user_cart_items_path(current_user)
      else
        @cart_item = current_user.cart_items.build(cart_item_params)
        if @cart_item.save
          flash[:success] = "カートに追加しました"
          redirect_to user_cart_items_path(current_user)
        else
          flash[:danger] = "追加にできませんでした"
          redirect_to menus_path
        end
      end
    elsif current_user.cart_items.present? && current_user.cart_items[0].menu.shop == @menu.shop
      if current_user.cart_already_include(@menu)
        @cart_item = CartItem.find_by(menu_id: @menu.id, user_id: current_user.id)
        @cart_item.update(
          amount: @cart_item.amount + params[:cart_item][:amount].to_i
        )
        flash[:success] = "カートに追加しました"
        redirect_to user_cart_items_path(current_user)
      else
        @cart_item = current_user.cart_items.build(cart_item_params)
        if @cart_item.save
          flash[:success] = "カートに追加しました"
          redirect_to user_cart_items_path(current_user)
        else
          flash[:danger] = "追加にできませんでした"
          redirect_to menus_path
        end
      end
    else
      flash[:danger] = "すでにカートの中に多店舗の商品があるため追加できません"
      redirect_to user_cart_items_path(current_user)
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
