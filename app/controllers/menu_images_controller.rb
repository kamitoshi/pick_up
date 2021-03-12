class MenuImagesController < ApplicationController
  before_action :set_menu

  def index

  end

  def new
    @menu_image = MenuImage.new
  end

  def create
    @menu_image = MenuImage.new(menu_image_params)
    @menu_image.save!
    redirect_to shops_menu_path(@menu_image.menu.id)
  end

  def edit
    @menu_image = MenuImage.find(params[:id])
  end

  def update
    @menu_image = MenuImage.find(params[:id])
    if admin_signed_in?
      if @menu_image.update(menu_image_params)
        flash[:success] = "変更を保存しました"
        redirect_to menu_menu_images_path(@menu)
      else
        flash[:danger] = "変更できませんでした"
        render :edit
      end
    elsif shop_signed_in?
      if @menu.shop == current_shop
        if @menu_image.update(menu_image_params)
          flash[:success] = "変更を保存しました"
          redirect_to menu_menu_images_path(@menu)
        else
          flash[:danger] = "変更できませんでした"
          render :edit
        end
      else
        flash[:danger] = "多店舗の商品画像は変更できません"
        redirect_to root_path
      end
    end
      
      
  end

  def destroy
    @menu_image = MenuImage.find[params[:id]]
    if @menu_image.destroy
      flash[:success] = "画像を削除しました"
      redirect_to menu_menu_images_path(@menu)
    else
      flash[:danger] = "削除できませんでした"
      redirect_to menu_menu_images_path(@menu)
    end
  end

  private

  def menu_image_params
    params.require(:menu_image).permit(:menu_id, :file_name, :is_main)
  end

  def set_menu
    @menu = Menu.find(params[:menu_id])
  end
end
