class MenuImagesController < ApplicationController
  before_action :set_menu

  def index
    @menu_images = @menu.menu_images
  end

  def new
    @menu_image = MenuImage.new
  end

  def create
    if admin_signed_in?
      if @menu.menu_images.count <= 4
        @menu_image = MenuImage.new(menu_image_params)
        if @menu_image.save
          flash[:success] = "商品の画像を追加しました"
          redirect_to menu_menu_images_path(@menu)
        else
          flash[:danger] = "画像を追加できませんでした"
          render :new
        end
      else
        flash[:danger] = "商品の画像は４枚までしか追加できません"
        redirect_to menu_menu_images_path(@menu)
      end
    elsif shop_signed_in?
      if @menu.menu_images.count <= 4
        if @menu.shop == current_shop
          @menu_image = MenuImage.new(menu_image_params)
          if @menu_image.save
            flash[:success] = "商品の画像を追加しました"
            redirect_to menu_menu_images_path(@menu)
          else
            flash[:danger] = "画像を追加できませんでした"
            render :new
          end
        else
          flash[:danger] = "他店が出品した商品の画像は追加できません"
          redirect_to root_path
        end
      else
        flash[:danger] = "商品の画像は４枚までしか追加できません"
        redirect_to menu_menu_images_path(@menu)
      end
    end
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
    @menu_image = MenuImage.find(params[:id])
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
