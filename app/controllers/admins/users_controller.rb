class Admins::UsersController < ApplicationController
  layout "shop_app"
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @orders = @user.orders
  end

  def edit
  end

  def update

  end

  private

  def user_params
    params.require(:user).permit(:last_name, :first_name, :kana_last_name, :kana_first_name, :phone_number, :email)
  end

end
