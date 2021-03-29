class ShopImagesController < ApplicationController
  before_action :set_shop

  def index
    @shop_images = @shop.shop_images
  end
  def new
    @shop_image = ShopImage.new
  end

  def create
    if @shop.shop_images.count < 4
      if @shop == current_shop
        @shop_image = @shop.shop_images.build(shop_image_params)
        if params[:shop_image].nil?
          flash.now[:danger] = "追加できませんでした。画像が選択されているか確認してください。"
          render :new
        else
          if @shop_image.save
            flash[:success] = "店舗の画像を追加しました"
            redirect_to shop_shop_images_path(current_shop)
          else
            flash.now[:danger] = "画像を追加できませんでした"
            render :new
          end
        end
      else
        flash[:danger] = "多店舗の画像は追加できません"
        redirect_to root_path
      end
    else
      flash[:danger] = "店舗イメージは４枚までしか登録できません"
      redirect_to shop_path(current_shop)
    end
  end

  def edit
    @shop_image = ShopImage.find(params[:id])
  end

  def update
    if @shop == current_shop
      @shop_image = ShopImage.find(params[:id])
      if params[:shop_image].nil?
        flash.now[:danger] = "編集できませんでした。画像が選択されているか確認してください。"
          render :edit
      else
        if @shop_image.update(shop_image_params)
          flash[:success] = "編集を保存しました"
          redirect_to shop_shop_images_path(current_shop)
        else
          flash.now[:danger] = "編集できませんでした"
          render :edit
        end
      end
    else
      flash[:danger] = "多店舗の画像は編集できません"
      redirect_to root_path
    end
  end

  def destroy
    if @shop == current_shop
      @shop_image = ShopImage.find(params[:id])
      if @shop_image.destroy
        flash[:success] = "削除しました"
        redirect_to shop_shop_images_path(current_shop)
      else
        flash[:danger] = "削除できませんでした"
        redirect_to shop_shop_images_path(current_shop)
      end
    else
      flash[:danger] = "多店舗の画像は削除できません"
      redirect_to root_path
    end
  end

  private

  def shop_image_params
    params.require(:shop_image).permit(:shop_id, :file_name, :is_main)
  end

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end
end
