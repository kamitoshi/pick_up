class BusinessHoursController < ApplicationController
  layout "shop_app"
  before_action :admin_or_shop!
  before_action :set_shop
  def index
    @business_hours = @shop.business_hours.order(job_time: "asc")
    unless @business_hours.present?
      redirect_to new_shop_business_hour_path(@shop)
    end
  end
  def new
    @business_hour = BusinessHour.new
  end

  def create
    all_day_business_hour = @shop.business_hours.find_by(job_time: "終日")
    @business_hour = @shop.business_hours.build(business_hour_params)
    if @business_hour.job_time == "終日"
      if all_day_business_hour.present?
        flash[:danger] = "すでに終日の営業時間が設定されています。編集から営業時間の変更をお願いします。"
        redirect_to shop_business_hours_path(@shop)
      else
        if already_set_business_hour?(@shop.business_hours)
          flash[:danger] = "終日の営業時間を設定する場合は、他の営業時間を消してください。"
          redirect_to shop_business_hours_path(@shop)
        else
          if @business_hour.save
            flash[:success] = "#{@business_hour.job_time}の営業時間を設定しました"
            redirect_to shop_business_hours_path(@shop)
          else
            flash[:danger] = "設定に失敗しました"
            render :new
          end
        end
      end
    else
      if all_day_business_hour.present?
        flash[:danger] = "#{@business_hour.job_time}を設定するには、終日営業時間を削除してください。"
        redirect_to shop_business_hours_path(@shop)
      else
        if @business_hour.job_time == "モーニング"
          if @shop.business_hours.find_by(job_time: "モーニング").present?
            flash[:danger] = "すでにモーニングの営業時間が設定されています。編集から営業時間の変更をお願いします。"
            redirect_to shop_business_hours_path(@shop)
          else
            if @business_hour.save
              flash[:success] = "#{@business_hour.job_time}の営業時間を設定しました"
              redirect_to shop_business_hours_path(@shop)
            else
              flash[:danger] = "設定に失敗しました"
              render :new
            end
          end
        elsif @business_hour.job_time == "ランチ"
          if @shop.business_hours.find_by(job_time: "ランチ").present?
            flash[:danger] = "すでにランチの営業時間が設定されています。編集から営業時間の変更をお願いします。"
            redirect_to shop_business_hours_path(@shop)
          else
            if @business_hour.save
              flash[:success] = "#{@business_hour.job_time}の営業時間を設定しました"
              redirect_to shop_business_hours_path(@shop)
            else
              flash[:danger] = "設定に失敗しました"
              render :new
            end
          end
        elsif @business_hour.job_time == "ディナー"
          if @shop.business_hours.find_by(job_time: "ディナー").present?
            flash[:danger] = "すでにディナーの営業時間が設定されています。編集から営業時間の変更をお願いします。"
            redirect_to shop_business_hours_path(@shop)
          else
            if @business_hour.save
              flash[:success] = "#{@business_hour.job_time}の営業時間を設定しました"
              redirect_to shop_business_hours_path(@shop)
            else
              flash[:danger] = "設定に失敗しました"
              render :new
            end
          end
        end
      end
    end
  end

  def edit
    if @shop == current_shop
      @business_hour = BusinessHour.find(params[:id])
    else
      redirect_to edit_shop_business_hour_path(@shop)
    end
  end
  
  def update
    @business_hour = BusinessHour.find(params[:id])
    if @shop == current_shop
      if @business_hour.update(business_hour_params)
        flash[:success] = "営業時間を変更しました"
        redirect_to shop_business_hours_path(@shop)
      else
        flash[:danger] = "変更できませんでした"
        render :edit
      end
    else
      flash[:danger] = "多店舗の営業時間は変更できません"
      redirect_to edit_shop_business_hour_path(@shop)
    end
  end

  def destroy
    @business_hour = BusinessHour.find(params[:id])
    if @shop == current_shop
      if @business_hour.destroy
        flash[:success] = "営業時間を削除しました"
        redirect_to shop_business_hours_path(@shop)
      else
        flash[:danger] = "削除できませんでした"
        redirect_to shop_business_hours_path(@shop)
      end
    else
      flash[:danger] = "多店舗の営業時間は削除できません"
      redirect_to shop_business_hours_path(@shop)
    end
  end

  private

  def business_hour_params
    params.require(:business_hour).permit(:shop_id, :job_time, :opening, :closing, :last_order)
  end

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

  def already_set_business_hour?(business_hours)
    if business_hours.present?
      business_hours.each do |business_hour|
        if business_hour.job_time == "モーニング" || business_hour.job_time == "ランチ" ||business_hour.job_time == "ディナー"
          return true
        end
      end
      return false
    else
      return false
    end
  end
  
end
