class ApplicationController < ActionController::Base

  def admin_or_shop!
    unless admin_signed_in? || shop_signed_in?
      flash[:danger] = "該当のページは店舗ユーザーとしてログインしていない場合閲覧できません"
      redirect_to new_shop_session_path
    end
  end

  def admin_or_user!
    unless admin_signed_in? || user_signed_in?
      flash[:danger] = "ログインしてください"
      redirect_to new_user_session_path
    end
  end

  def set_menu_ransack
    @q = Menu.ransack(params[:q])
  end
  def set_shop_ransack
    @q = Shop.ransack(params[:q])
  end

end
