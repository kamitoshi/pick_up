class ShopImagesController < ApplicationController
  layout "shop_app"
  before_action :admin_or_shop!
  before_action :set_shop

  def index
    @shop_images = @shop.shop_images
    @main_image = @shop.shop_images.find_by(is_main: true)
  end
  def new
    @shop_image = ShopImage.new
  end

  def create
    if shop_signed_in?
      if @shop.shop_images.count < 4
        if @shop == current_shop
          if params[:shop_image][:is_main] == "true"
            if @shop.shop_images.present?
              @shop.shop_images.each do |image|
                if image.is_main?
                  image.update(is_main: false)
                end
              end
              @shop_image = @shop.shop_images.build(shop_image_params)
              if @shop_image.save
                flash[:success] = "店舗のメイン画像を追加しました"
                redirect_to shop_shop_images_path(@shop)
              else
                flash[:danger] = "画像を追加できませんでした。ファイルを選択してください"
                render :new
              end
            else
              @shop_image = @shop.shop_images.build(shop_image_params)
              if @shop_image.save
                flash[:success] = "店舗のメイン画像を追加しました"
                redirect_to shop_shop_images_path(@shop)
              else
                flash[:danger] = "画像を追加できませんでした。ファイルを選択してください"
                render :new
              end
            end
          else
            if @shop.shop_images.present?
              @shop_image = @shop.shop_images.build(shop_image_params)
              if @shop_image.save
                flash[:success] = "店舗の画像を追加しました"
                redirect_to shop_shop_images_path(@shop)
              else
                flash[:danger] = "画像を追加できませんでした。"
                render :new
              end
            else
              @shop_image = @shop.shop_images.build(shop_image_params)
              @shop_image.is_main = true
              if @shop_image.save
                flash[:success] = "店舗のメイン画像を追加しました"
                redirect_to shop_shop_images_path(@shop)
              else
                flash[:danger] = "画像を追加できませんでした。ファイルを選択してください"
                render :new
              end
            end
          end
        else
          flash[:danger] = "他店の画像は追加できません"
          redirect_to root_path
        end
      else
        flash[:danger] = "店舗イメージは４枚までしか登録できません"
        redirect_to shop_path(current_shop)
      end
    elsif admin_signed_in?
      if params[:shop_image][:is_main] == "true"
        if @shop.shop_images.present?
          @shop.shop_images.each do |image|
            if image.is_main?
              image.update(is_main: false)
            end
          end
          @shop_image = @shop.shop_images.build(shop_image_params)
          if @shop_image.save
            flash[:success] = "店舗のメイン画像を追加しました"
            redirect_to shop_shop_images_path(@shop)
          else
            flash[:danger] = "画像を追加できませんでした。ファイルを選択してください"
            render :new
          end
        else
          @shop_image = @shop.shop_images.build(shop_image_params)
          if @shop_image.save
            flash[:success] = "店舗のメイン画像を追加しました"
            redirect_to shop_shop_images_path(@shop)
          else
            flash[:danger] = "画像を追加できませんでした。ファイルを選択してください"
            render :new
          end
        end
      else
        if @shop.shop_images.present?
          @shop_image = @shop.shop_images.build(shop_image_params)
          if @shop_image.save
            flash[:success] = "店舗の画像を追加しました"
            redirect_to shop_shop_images_path(@shop)
          else
            flash[:danger] = "画像を追加できませんでした。"
            render :new
          end
        else
          @shop_image = @shop.shop_images.build(shop_image_params)
          @shop_image.is_main = true
          if @shop_image.save
            flash[:success] = "店舗のメイン画像を追加しました"
            redirect_to shop_shop_images_path(@shop)
          else
            flash[:danger] = "画像を追加できませんでした。ファイルを選択してください"
            render :new
          end
        end
      end
    end
  end

  def edit
    @shop_image = ShopImage.find(params[:id])
  end

  def update
    @shop_image = ShopImage.find(params[:id])
    if shop_signed_in?
      if @shop == current_shop
        if params[:shop_image][:is_main] == "true"
          @main_image = @shop.shop_images.find_by(is_main: true)
          if @shop_image.update(shop_image_params)
            @main_image.update(is_main: false)
            flash[:success] = "変更を保存しました"
            redirect_to shop_shop_images_path(@shop)
          else
            flash[:danger] = "変更できませんでした"
            render :edit
          end
        else
          if @shop_image.update(shop_image_params)
            flash[:success] = "変更を保存しました"
            redirect_to shop_shop_images_path(@shop)
          else
            flash[:danger] = "変更できませんでした"
            render :edit
          end
        end
      else
        flash[:danger] = "多店舗の画像は編集できません"
        redirect_to root_path
      end
    elsif
      if params[:shop_image][:is_main] == "true"
        @main_image = @shop.shop_images.find_by(is_main: true)
        if @shop_image.update(shop_image_params)
          @main_image.update(is_main: false)
          flash[:success] = "変更を保存しました"
          redirect_to shop_shop_images_path(@shop)
        else
          flash[:danger] = "変更できませんでした"
          render :edit
        end
      else
        if @shop_image.update(shop_image_params)
          flash[:success] = "変更を保存しました"
          redirect_to shop_shop_images_path(@shop)
        else
          flash[:danger] = "変更できませんでした"
          render :edit
        end
      end
    end
  end

  def destroy
    if shop_signed_in?
      if @shop == current_shop
        @shop_image = @shop.shop_images.find(params[:id])
        if @shop_image.is_main?
          flash[:danger] = "メイン画像は削除できません"
          redirect_to shop_shop_images_path(@shop)
        else
          if @shop_image.destroy
            flash[:success] = "画像を削除しました"
            redirect_to shop_shop_images_path(@shop)
          else
            flash[:danger] = "削除できませんでした"
            redirect_to shop_shop_images_path(@shop)
          end
        end
      else
        flash[:danger] = "多店舗の画像は削除できません"
        redirect_to root_path
      end
    elsif
      @shop_image = @shop.shop_images.find(params[:id])
      if @shop_image.is_main?
        flash[:danger] = "メイン画像は削除できません"
        redirect_to shop_shop_images_path(@shop)
      else
        if @shop_image.destroy
          flash[:success] = "画像を削除しました"
          redirect_to shop_shop_images_path(@shop)
        else
          flash[:danger] = "削除できませんでした"
          redirect_to shop_shop_images_path(@shop)
        end
      end
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
