class OrderMailer < ApplicationMailer
  
  def send_user_order(order) #メソッドに対して引数を設定
    @user = order.user #ユーザー情報
    @shop = order.shop #ショップ情報
    @order = order
    mail to: @shop.email, subject: '【PickUp】 注文が入りました'
  end
  
  def send_return_reception_order(order)
    @user = order.user #ユーザー情報
    @shop = order.shop #ショップ情報
    @order = order
    mail to: @user.email, subject: '【PickUp】 注文の受付が完了しました'
  end

  def send_return_cancel_order(order)
    @user = order.user #ユーザー情報
    @shop = order.shop #ショップ情報
    @order = order
    mail to: @user.email, subject: '【PickUp】 注文がキャンセルされました'
  end

end
