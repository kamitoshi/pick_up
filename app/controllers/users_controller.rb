class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user == current_user
      if @user.update(user_params)
        flash[:success] = "変更を保存しました"
        redirect_to user_path(@user)
      else
        flash[:danger] = "変更できませんでした"
        render "edit"
      end
    else
      flash[:danger] = "他人の情報は変更できません"
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:last_name, :first_name, :kana_last_name, :kana_first_name, :phone_number, :email)
  end

end
