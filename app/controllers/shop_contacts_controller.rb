class ShopContactsController < ApplicationController
  layout "shop_app"
  before_action :admin_or_shop!, only:[:index, :show]

  def index
  end

  def show
  end

  def new
    @shop_contact = ShopContact.new
  end

  def create
    @shop_contact = ShopContact.new(shop_contact_params)
    if @shop_contact.save
      redirect_to fix_shop_contacts_path
    else
      flash.now[:danger] = "必須項目が入力されていません。入力内容を確認してください。"
      render :new
    end
  end

  def fix

  end

  private
  
  def shop_contact_params
    params.require(:shop_contact).permit(:shop_name, :staff_name, :phone_number, :email, :shop_address, :content)
  end
end
