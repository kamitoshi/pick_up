class BusinessHoursController < ApplicationController
  before_action :set_shop
  def index
    @business_hours = @shop.business_hours.order(job_time: "asc")
    unless @business_hours.present?
      redirect_to new_shop_business_hour_path(current_shop)
    end
  end
  def new
    @business_hour = BusinessHour.new
  end

  def create
    @business_hour = @shop.business_hours.build(business_hour_params)
    if @business_hour.save
      flash[:success] = "営業時間を設定しました"
      redirect_to shop_business_hours_path(current_shop)
    else
      flash[:danger] = "設定に失敗しました"
      render :new
    end
  end

  def edit
    if @shop == current_shop
      @business_hour = BusinessHour.find(params[:id])
    else
      redirect_to edit_shop_business_hour_path(current_shop)
    end
  end
  
  def update
    @business_hour = BusinessHour.find(params[:id])
    if @shop == current_shop
      if @business_hour.update(business_hour_params)
        flash[:success] = "営業時間を変更しました"
        redirect_to shop_business_hours_path(current_shop)
      else
        flash[:danger] = "変更できませんでした"
        render :edit
      end
    else
      flash[:danger] = "多店舗の営業時間は変更できません"
      redirect_to edit_shop_business_hour_path(current_shop)
    end
  end

  def destroy
    @business_hour = BusinessHour.find(params[:id])
    if @shop == current_shop
      if @business_hour.destroy
        flash[:success] = "営業時間を削除しました"
        redirect_to shop_business_hours_path(current_shop)
      else
        flash[:danger] = "削除できませんでした"
        redirect_to shop_business_hours_path(current_shop)
      end
    else
      flash[:danger] = "多店舗の営業時間は削除できません"
      redirect_to shop_business_hours_path(current_shop)
    end
  end

  private

  def business_hour_params
    params.require(:business_hour).permit(:shop_id, :job_time, :opening, :closing, :last_order)
  end

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end
end
