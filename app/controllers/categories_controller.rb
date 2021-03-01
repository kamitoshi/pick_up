class CategoriesController < ApplicationController
  before_action :only_use!

  def index
    @categories = Category.all
    @category = Category.new
  end

  def new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path
    else
      @categories = Category.all
      render "index"
    end
  end

  def edit
    @categories = Category.all
    @category = Category.new
    @target_category = Category.find(params[:id])
  end

  def update
    @target_category = Category.find(params[:id])
    if @target_category.update(category_params)
      redirect_to categories_path
    else
      redirect_to categories_path
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def only_use!
    unless admin_signed_in? || shop_signed_in?
      redirect_to root_path
    end
  end
end
