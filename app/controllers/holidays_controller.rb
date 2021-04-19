class HolidaysController < ApplicationController
  layout "shop_app"
  before_action :admin_or_shop!
  before_action :set_shop

  def index
    @holidays = @shop.holidays.order(weekday: "asc")
    unless @holidays.present?
      redirect_to new_shop_holiday_path(@shop)
    end
  end

  def new
    @holiday = Holiday.new
  end

  def create
    holidays = @shop.holidays
    if shop_signed_in?
      if @shop.already_set_holiday?(params[:holiday][:weekday])
        @holiday = @shop.holidays.build(holiday_params)
        flash.now[:danger] = "すでにその曜日は定休日として設定されています"
        render :new
      else
        @holiday = @shop.holidays.build(holiday_params)
        if @holiday.save
          flash[:success] = "定休日を設定しました"
          redirect_to shop_holidays_path(@shop)
        else
          flash.now[:danger] = "定休日を選択してください"
          render :new
        end
      end
    elsif admin_signed_in?
      if @shop.already_set_holiday?(params[:holiday][:weekday])
        flash.now[:danger] = "すでにその曜日は定休日として設定されています"
        render :new
      else
        @holiday = @shop.holidays.build(holiday_params)
        if @holiday.save
          flash[:success] = "定休日を設定しました"
          redirect_to shop_holidays_path(@shop)
        else
          flash.now[:danger] = "定休日を選択してください"
          render :new
        end
      end
    end
  end

  def destroy
    @holiday = @shop.holidays.find(params[:id])
    if shop_signed_in?
      if @holiday.shop == current_shop
        if @holiday.destroy
          flash[:success] = "定休日を削除しました"
          redirect_to shop_holidays_path(@shop)
        else
          flash[:danger] = "削除できませんでした"
          redirect_to shop_holiday_path(@shop)
        end
      else
        flash[:danger] = "多店舗の定休日は削除できません"
        redirect_to shop_holiday_path(@shop)
      end
    end
  end

  private

  def holiday_params
    params.require(:holiday).permit(:shop_id, :weekday)
  end

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end
end
