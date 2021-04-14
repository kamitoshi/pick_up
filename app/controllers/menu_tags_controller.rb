class MenuTagsController < ApplicationController
  layout "shop_app"
  before_action :admin_or_shop!
  before_action :set_menu

  def new
    @menu_tag = MenuTag.new
  end

  def create
    menu_tags = MenuTag.where(menu_id: @menu.id)
    if menu_tags.count < 10
      @menu_tag = @menu.menu_tags.build(menu_tag_params)
      if shop_signed_in?
        if @menu.shop == current_shop
          if @menu_tag.save
            flash[:success] = "キーワードを追加しました"
            redirect_to new_menu_menu_tag_path(@menu)
          else
            flash.now[:danger] = "追加できませんでした"
            render :new
          end
        else
          flash[:danger] = "他店のメニューにキーワードは追加できません"
          redirect_to root_path
        end
      elsif admin_signed_in?
        if @menu_tag.save
          flash[:success] = "キーワードを追加しました"
          redirect_to new_menu_menu_tag_path(@menu)
        else
          flash.now[:danger] = "追加できませんでした"
          render :new
        end
      end
    else
      flash[:danger] = "キーワードは１０個までしか設定できません"
      redirect_to new_menu_menu_tag_path(@menu)
    end
  end

  def destroy
    @menu_tag = MenuTag.find(params[:id])
    if shop_signed_in?
      if @menu.shop == current_shop
        if @menu_tag.destroy
          flash[:success] = "削除しました"
          redirect_to new_menu_menu_tag_path(@menu)
        else
          flash[:danger] = "削除できませんでした"
          redirect_to new_menu_menu_tag_path(@menu)
        end
      else
        flash[:danger] = "他店のキーワードは削除できません"
        redirect_to root_path
      end
    elsif admin_signed_in?
      if @menu_tag.destroy
        flash[:success] = "削除しました"
        redirect_to new_menu_menu_tag_path(@menu)
      else
        flash[:danger] = "削除できませんでした"
        redirect_to new_menu_menu_tag_path(@menu)
      end
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
