class ShopTagsController < ApplicationController
  before_action :set_shop
  def new
    @shop_tag = ShopTag.new
  end

  def create
    @shop_tag = @shop.shop_tags.build(shop_tag_params)
    if @shop == current_shop
      if @shop_tag.save!
        flash[:success] = "タグを追加しました"
        redirect_to edit_shop_path(current_shop)
      else
        flash[:danger] = "タグを追加できませんでした"
        redirect_to edit_shop_path(current_shop)
      end
    else
      flash[:danger] = "他店のタグは追加できません"
      redirect_to root_path
    end
  end

  def edit
    @shop_tag = ShopTag.find(params[:id])
  end

  def update
    @shop_tag = ShopTag.find(params[:id])
    if @shop == current_shop
      if @shop_tag.update!(shop_tag_params)
        flash[:success] = "変更を保存しました"
        redirect_to edit_shop_path(current_shop)
      else
        flash[:danger] = "変更できませんでした"
        redirect_to edit_shop_path(current_shop)
      end
    else
      flash[:danger] = "他店のタグは編集できません"
      redirect_to root_path
    end
  end

  def destroy
    @shop_tag = ShopTag.find(params[:id])
    if @shop == current_shop
      if @shop_tag.destroy
        flash[:success] = "削除しました"
        redirect_to edit_shop_path(current_shop)
      else
        flash[:danger] = "削除できませんでした"
        redirect_to edit_shop_path(current_shop)
      end
    else
      flash[:danger] = "他店のタグは削除できません"
      redirect_to root_path
    end
  end

  private

  def shop_tag_params
    params.require(:shop_tag).permit(:shop_id, :content)
  end
  
  def set_shop
    @shop = Shop.find(params[:shop_id])
  end
end
