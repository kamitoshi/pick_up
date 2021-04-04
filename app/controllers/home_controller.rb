class HomeController < ApplicationController
  layout "users_layout"
  def index
    @menus = Menu.all
    @shops = Shop.all
  end

  def top
  end

  def anout

  end

  def method

  end

  def privacy

  end

  def term
    
  end
end
