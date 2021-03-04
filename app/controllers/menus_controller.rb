class MenusController < ApplicationController
  
  def new
    @menu = Menu.new
  end

  def create
    menu = Menu.new(menu_params)
    if admin_signed_in?
      menu.shop_id = params[:shop_id]
      if menu.save
        flash[:success] = "メニューを追加しました"
        redirect_to shops_menus_path
      else
        flash[:danger] = "メニューの追加に失敗しました"
        render "new"
      end
    elsif shop_signed_in?
      menu.shop_id = current_shop.id
      if menu.save
        flash[:success] = "メニューを追加しました"
        redirect_to shops_menus_path
      else
        flash[:danger] = "メニューの追加に失敗しました"
        render "new"
      end
    else
      flash[:danger] = "ログインしてください"
      redirect_to root_path
    end
    
  end

  def edit
    @menu = Menu.find(params[:id])
  end

  def update
    @menu = Menu.find(params[:id])
    if admin_signed_in?
      if @menu.update(menu_params)
        flash[:success] = "編集を保存しました"
        redirect_to admins_menu_path(@menu)
      else
        flash[:danger] = "編集できませんでした"
        render "edit"
      end
    else shop_signed_in?
      if @menu.shop == current_shop
        if @menu.update(menu_params)
          flash[:success] = "編集を保存しました"
          redirect_to shops_menu_path(@menu)
        else
          flash[:danger] = "編集できませんでした"
          render "edit"
        end
      else
        flash[:danger] = "自店舗のメニュー以外編集できません"
        redirect_to shops_menus_path
      end
    end
  end

  def destroy
    @menu = Menu.find(params[:id])
    if admins_signed_in?
      if @menu.destroy
        flash[:success] = "削除しました"
        redirect_to admins_menus_path
      else
        flash.now[:danger] = "削除できませんでした"
      end
    elsif shop_signed_in?
      if @menu.shop == current_shop
        if @menu.destroy
          flash[:success] = "削除しました"
          redirect_to shops_menus_path
        else
          flash.now[:danger] = "削除できませんでした"
        end
      else
        flash[:danger] = "自店舗のメニュー以外削除できません"
        redirect_to shops_menus_path
      end
    else
      flash[:danger] = "ログインしてください"
      redirect_to root_path
    end
  end

  private

  def menu_params
    params.require(:menu).permit(:shop_id, :name, :price, :special_price, :fee, :introduction, :is_active, :is_saling)
  end

end
