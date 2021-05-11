class OrderMailer < ApplicationMailer
  
  def send_user_order(order) #メソッドに対して引数を設定
    @user = order.user #ユーザー情報
    @shop = order.shop #ショップ情報
    @order = order
    mail to: @shop.email, subject: '注文が入りました'
  end
  
  def send_return_reception_order(order)
    @user = order.user #ユーザー情報
    @shop = order.shop #ショップ情報
    @order = order
    mail to: @user.email, subject: 'ご注文の受付が確定しました'
  end

  def send_return_cancel_order(order)
    @user = order.user #ユーザー情報
    @shop = order.shop #ショップ情報
    @order = order
    mail to: @user.email, subject: 'ご注文がキャンセルになりました'
  end

end
