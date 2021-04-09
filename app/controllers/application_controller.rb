class ApplicationController < ActionController::Base
  before_action :set_ransack

  def admin_or_shop!
    unless admin_signed_in? || shop_signed_in?
      flash[:danger] = "店舗ユーザーとしてログインしてください"
      redirect_to new_shop_session_path
    end
  end

  def admin_or_user!
    unless admin_signed_in? || user_signed_in?
      flash[:danger] = "ログインしてください"
      redirect_to new_user_session_path
    end
  end

  def set_ransack
    @q = Menu.ransack(params[:q])
  end

end
