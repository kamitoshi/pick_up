class MenuImagesController < ApplicationController
  layout "shop_app"
  before_action :admin_or_shop!
  before_action :set_menu

  def index
    @menu_images = @menu.menu_images.order(is_main: "desc")
    @main_image = @menu_images.find_by(is_main: true)
  end

  def new
    @menu_image = MenuImage.new
  end

  def create
    if admin_signed_in?
      if @menu.menu_images.count < 4
        if params[:menu_image][:is_main].present?
          if @menu.menu_images.present?
            @menu.menu_images.each do |image|
              if image.is_main?
                image.update(is_main: false)
              end
            end
            @menu_image = @menu.menu_images.build(menu_image_params)
            if @menu_image.save
              flash[:success] = "商品のメイン画像を追加しました"
              redirect_to menu_menu_images_path(@menu)
            else
              flash[:danger] = "画像を追加できませんでした。ファイルを選択してください"
              render :new
            end
          else
            @menu_image = @menu.menu_images.build(menu_image_params)
            if @menu_image.save
              flash[:success] = "商品のメイン画像を追加しました"
              redirect_to menu_menu_images_path(@menu)
            else
              flash[:danger] = "画像を追加できませんでした。ファイルを選択してください"
              render :new
            end
          end
        else
          if @menu.menu_images.present?
            @menu_image = @menu.menu_images.build(menu_image_params)
            if @menu_image.save
              flash[:success] = "商品の画像を追加しました"
              redirect_to menu_menu_images_path(@menu)
            else
              flash[:danger] = "画像を追加できませんでした。ファイルを選択してください"
              render :new
            end
          else
            @menu_image = @menu.menu_images.build(menu_image_params)
            @menu_image.is_main = true
            if @menu_image.save
              flash[:success] = "商品のメイン画像を追加しました"
              redirect_to menu_menu_images_path(@menu)
            else
              flash[:danger] = "画像を追加できませんでした。ファイルを選択してください"
              render :new
            end
          end
        end
      else
        flash[:danger] = "商品の画像は４枚までしか追加できません"
        redirect_to menu_menu_images_path(@menu)
      end
    elsif shop_signed_in?
      if @menu.menu_images.count < 4
        if @menu.shop == current_shop
          if params[:menu_image].present?
            if params[:menu_image][:is_main] == "true"
              if @menu.menu_images.present?
                @menu.menu_images.each do |image|
                  if image.is_main?
                    image.update(is_main: false)
                  end
                end
                @menu_image = @menu.menu_images.build(menu_image_params)
                if @menu_image.save
                  flash[:success] = "商品のメイン画像を追加しました"
                  redirect_to menu_menu_images_path(@menu)
                else
                  flash[:danger] = "画像を追加できませんでした。ファイルを選択してください"
                  render :new
                end
              else
                @menu_image = @menu.menu_images.build(menu_image_params)
                if @menu_image.save
                  flash[:success] = "商品のメイン画像を追加しました"
                  redirect_to menu_menu_images_path(@menu)
                else
                  flash[:danger] = "画像を追加できませんでした。ファイルを選択してください"
                  render :new
                end
              end
            else
              if @menu.menu_images.present?
                @menu_image = @menu.menu_images.build(menu_image_params)
                if @menu_image.save
                  flash[:success] = "商品の画像を追加しました"
                  redirect_to menu_menu_images_path(@menu)
                else
                  flash[:danger] = "画像を追加できませんでした。"
                  render :new
                end
              else
                @menu_image = @menu.menu_images.build(menu_image_params)
                @menu_image.is_main = true
                if @menu_image.save
                  flash[:success] = "商品のメイン画像を追加しました"
                  redirect_to menu_menu_images_path(@menu)
                else
                  flash[:danger] = "画像を追加できませんでした。ファイルを選択してください"
                  render :new
                end
              end
            end
          else
            @menu_image = MenuImage.new
            flash.now[:danger] = "画像を選択してください"
            render :new
          end
        else
          @menu_image = MenuImage.new
          flash[:danger] = "他店が出品した商品の画像は追加できません"
          redirect_to root_path
        end
      else
        @menu_image = MenuImage.new
        flash[:danger] = "商品の画像は４枚までしか追加できません"
        redirect_to menu_menu_images_path(@menu)
      end
    end
  end

  def edit
    @menu_image = @menu.menu_images.find(params[:id])
  end

  def update
    @menu_image = @menu.menu_images.find(params[:id])
    if admin_signed_in?
      if params[:menu_image].nil?
        flash.now[:danger] = "商品の画像を選択してください"
        render :edit
      else
        if @menu_image.update(menu_image_params)
          flash[:success] = "変更を保存しました"
          redirect_to menu_menu_images_path(@menu)
        else
          flash[:danger] = "変更できませんでした"
          render :edit
        end
      end
    elsif shop_signed_in?
      if @menu.shop == current_shop
        if params[:menu_image].present?
          if params[:menu_image][:is_main] == "true"
            @main_image = @menu.menu_images.find_by(is_main: true)
            if @menu_image.update(menu_image_params)
              @main_image.update(is_main: false)
              flash[:success] = "変更を保存しました"
              redirect_to menu_menu_images_path(@menu)
            else
              flash[:danger] = "変更できませんでした"
              render :edit
            end
          else
            if @menu_image.update(menu_image_params)
              flash[:success] = "変更を保存しました"
              redirect_to menu_menu_images_path(@menu)
            else
              flash[:danger] = "変更できませんでした"
              render :edit
            end
          end
        else
          flash.now[:danger] = "画像を選択してください"
          render :edit
        end
      else
        flash[:danger] = "多店舗の商品画像は変更できません"
        redirect_to root_path
      end
    end  
  end

  def destroy
    if @menu.shop == current_shop
      @menu_image = @menu.menu_images.find(params[:id])
      if @menu_image.is_main?
        flash[:danger] = "メイン画像は削除できません"
        redirect_to menu_menu_images_path(@menu)
      else
        if @menu_image.destroy
          flash[:success] = "画像を削除しました"
          redirect_to menu_menu_images_path(@menu)
        else
          flash[:danger] = "削除できませんでした"
          redirect_to menu_menu_images_path(@menu)
        end
      end
    else
      flash[:danger] = "多店舗のメニューは削除できません"
      redirect_to root_path
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
