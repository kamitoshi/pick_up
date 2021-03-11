class ShopImagesController < ApplicationController
  def new
    @shop_image = ShopImage.new
  end

  def create
    @shop_image = ShopImage.new(shop_image_params)
    @shop_image.save!
    redirect_to shop_path(current_shop)
  end

  def edit
  end

  def update

  end

  def destroy

  end

  private

  def shop_image_params
    params.require(:shop_image).permit(:shop_id, :file_name, :is_main)
  end

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end
end
