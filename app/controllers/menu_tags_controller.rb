class MenuTagsController < ApplicationController
  before_action :set_menu

  def create
    menu_tags = MenuTag.where(menu_id: @menu.id)
    if menu_tags.count <= 10
      @menu_tag = @menu.menu_tags.build(menu_tag_params)
      if @menu.shop == current_shop
        if @menu_tag.save
          flash[:success] = "タグを追加しました"
          redirect_to shops_menu_path(@menu)
        else
          flash[:danger] = "タグを追加できませんでした"
          redirect_to shops_menu_path(@menu)
        end
      else
        flash[:danger] = "他店のメニューにタグは追加できません"
        redirect_to root_path
      end
    else
      flash[:danger] = "タグは１０個までしか設定できません"
      redirect_to shops_menu_path(@menu)
    end
  end

  def destroy
    @menu_tag = MenuTag.find(params[:id])
    if @menu.shop == current_shop
      if @menu_tag.destroy
        flash[:success] = "削除しました"
        redirect_to shops_menu_path(@menu)
      else
        flash[:danger] = "削除できませんでした"
        redirect_to shops_menu_path(@menu)
      end
    else
      flash[:danger] = "他店のメニュータグは削除できません"
      redirect_to root_path
    end
  end

  private

  def menu_tag_params
    params.require(:menu_tag).permit(:menu_id, :content)
  end

  def set_menu
    @menu = Menu.find(params[:menu_id])
  end
end
