class OrderMailer < ApplicationMailer
  def send_user_order(order) #メソッドに対して引数を設定
    @user = order.user #ユーザー情報
    @shop = order.shop #ショップ情報
    @order = order
    mail to: @shop.email, subject: '【PickUp】 テイクアウトの注文が入りました'
  end
end
